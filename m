Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1FPSmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:42:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab1FPSmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=goqlNaalus7B5MQ5sGCL9G9/6svlfh9D1O9xPTlAi9hF8owELY3vU/IVMThHvbeJvC
         thabw8PGj+UKThPp/zhzGidTLTSEfAU+sQAk3shiAaOSD2TV5YGvTUIubdc7ZoLg+ZkJ
         eADl2svb4ZhkLeX5KuUlpqWsptRaGO1cc9biY=
MIME-Version: 1.0
In-Reply-To: <4DFA485C.4090300@interlog.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
 <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com> <4DFA44D4.2010602@interlog.com>
 <BANLkTimHMM6gNcFFP62eU-SUfaCPyhWE_A@mail.gmail.com> <4DFA485C.4090300@interlog.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 16 Jun 2011 20:31:12 +0200
Message-ID: <BANLkTi=eDA1Oa1cVdVNozYu-K5Z0i1uv2g@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 16 Jun 2011 18:32:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 20:15, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 11-06-16 02:05 PM, Kay Sievers wrote:
>>> The kernel's device naming (following from how devices are
>>> discovered) is topological. However at higher levels
>>> the user is interested in the device identity. So if
>>> unique device names were used as preferred names and
>>> preferred names were unique (in a Linux system at any
>>> given time) then any subsequent path to an existing device
>>> would be highlighted. [That is because subsequent attempts
>>> to create its preferred name would fail because it is
>>> already there.]
>>>
>>> You don't need thousands of dollars of equipment to
>>> demonstrate this point. An external single disk
>>> SATA enclosure with a USB and eSATA interface will do.
>>
>> Udev does that already since quite a while. This is my cheap laptop:
>>   # find /dev/disk/ -name "wwn*"
>>   /dev/disk/by-id/wwn-0x50015179593f3038-part1
>>   /dev/disk/by-id/wwn-0x50015179593f3038-part4
>>   /dev/disk/by-id/wwn-0x50015179593f3038-part3
>>   /dev/disk/by-id/wwn-0x50015179593f3038-part2
>>   /dev/disk/by-id/wwn-0x50015179593f3038
>
> That is my point, if that disk is eSATA and USB connected
> which transport is that link pointing to? I would
> prefer eSATA over USB any day but is udev that smart? Or
> are we just seeing a symlink to the first (or perhaps last)
> path discovered?

I don't know if any bridge supports both connections at the same time.
Mine doesn't.

If two kernel devices fight for the same link, the last one wins,
unless there are link-priorities specified in udev rules.

Kay
