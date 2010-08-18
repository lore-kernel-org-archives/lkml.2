Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0HRNFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:05:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33206 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0HRNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:05:03 -0400
Message-ID: <4C6BDA6E.1060300@canonical.com>
Date: Wed, 18 Aug 2010 21:04:46 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera
 power
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282127719.2747.211.camel@localhost>
In-Reply-To: <1282127719.2747.211.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 06:35 PM, David Woodhouse wrote:
> On Wed, 2010-08-18 at 09:36 +0100, Ike Panhc wrote:
>>
>> Once the rfkill of a laptop is set to block, it is no way to unblock with Linux
>> without driver. Thanks for David Woodhouse wrote the first driver solving this.
>>
>> But the \_SB_.GECN and \_SB_.DECN are only available on Lenovo ideapad S10-3.
>> Using EC command to control rf/camera power is better because I believe every
>> ideapads which has VPC2004 device in its DSDT has this common method.
>>
>> This driver is tested and work fine on Lenovo ideapad B550 and ideapad S10-3.
> 
> Works for me too (on S10-3); thanks.
> 
> It all looks good, although should we have a delay or a schedule or at
> least a cpu_relax() in the read_ec_data() and write_ec_cmd() loops?
> Those loops should be using time_before() too, rather than open-coding
> the comparison.
> 
yeah, agree. polling from ec makes cpu busy, although its usually less then 10ms
a yield or relax will be good.
