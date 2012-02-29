Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965804Ab2B2B16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:27:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab2B2B1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:27:55 -0500
Message-ID: <4F4D7F5E.5040202@cn.fujitsu.com>
Date: Wed, 29 Feb 2012 09:29:02 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com>
In-Reply-To: <4F4CB926.6050600@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 09:26:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 09:26:06,
	Serialize complete at 2012-02-29 09:26:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 02/28/2012 07:23 PM, Avi Kivity Wrote:
> On 02/27/2012 05:01 AM, Wen Congyang wrote:
>> We can know the guest is paniced when the guest runs on xen.
>> But we do not have such feature on kvm. This patch implemnts
>> this feature, and the implementation is the same as xen:
>> register panic notifier, and call hypercall when the guest
>> is paniced.
> 
> What's the motivation for this?  "Xen does this" is insufficient.

Another purpose is: management app(for example: libvirt) can do auto
dump when the guest is crashed. If management app does not do auto
dump, the guest's user can do dump by hand if he sees the guest is
paniced.

I am thinking about another status: dumping. This status tells
the guest's user that the guest is paniced, and the OS's dump function
is working.

These two status can tell the guest's user whether the guest is pancied,
and what should he do if the guest is paniced.

Thanks
Wen Congyang
