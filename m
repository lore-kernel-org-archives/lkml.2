Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1HDHX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:23:59 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:34312 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HDHXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:23:52 -0400
Message-ID: <4E3A4904.3040007@ge.com>
Date: Thu, 04 Aug 2011 08:23:48 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch> <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu>
In-Reply-To: <20110803152317.GA21903@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2011 07:20:39.0514 (UTC) FILETIME=[0332ABA0:01CC5277]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/11 16:23, Emilio G. Cota wrote:
> On Wed, Aug 03, 2011 at 16:06:30 +0200, Manohar Vanga wrote:
>> Hey Martyn,
>>
>>> Can we not do this inside vme_master_request, vme_slave_request, etc?
>>>
>>> I.e. Add reference count when resources are given out.
>>>
>>> This would then be done in the vme_*_free routines.
>>
>> I agree this would be much better. I will change this and resend :)
> 
> To me it seems better to keep this as is, to be
> used by .probe and .release methods, in the same way
> usb_get_dev() and usb_put_dev() are used by usb drivers.
> 

The description of the functions in usb.c suggests, to me at least, that these
functions are the equivalent to the vme_*_request functions in the vme code.
Being called when a function binds to an interface and when it is finished
with it.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
