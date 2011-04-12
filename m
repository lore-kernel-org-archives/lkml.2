Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1DLTWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:22:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62620 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1DLTWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HiaoeFtzLqFqq9I9UT+UdJEap8LzBRDu+11EFvDeCrgNhKySyLAdnLaN4ezxChZkek
         xvyvgzGYytXXrmhd5eDZGIKUx70I4+degtwuXxBFcD/1T16IiPnlfDEPZFdWmK9gUge0
         ytdRJ6z7J/CQ0Y4mrYzLgofdQuHhfFIYYgYZE=
MIME-Version: 1.0
In-Reply-To: <20110412192014.GF16342@mtj.dyndns.org>
References: <201104121609.56901.richard@nod.at>
	<alpine.DEB.2.00.1104121309480.14692@router.home>
	<201104122041.11460.richard@nod.at>
	<20110412192014.GF16342@mtj.dyndns.org>
Date: Tue, 12 Apr 2011 22:22:47 +0300
X-Google-Sender-Auth: DyJND1yKcwslMSCWBP0mO5lJAjg
Message-ID: <BANLkTimsw1N=0QkEsySBE58GJx7g12XQpQ@mail.gmail.com>
Subject: Re: um: this_cpu_cmpxchg16b_emu
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:41:11PM +0200, Richard Weinberger wrote:
>> Am Dienstag 12 April 2011, 20:10:37 schrieb Christoph Lameter:
>> > On Tue, 12 Apr 2011, Richard Weinberger wrote:
>> > > This patch implements this_cpu_cmpxchg16b_emu() for UML.
>> >
>> > Is this really necessary? Just undefine CONFIG_CMPXCHG_LOCAL for UML and
>> > the asm code will not be used.
>>
>> UML includes arch/x86/Kconfig.cpu which defines CONFIG_CMPXCHG_LOCAL automatically.
>> Just disabling CONFIG_CMPXCHG_LOCAL for UML is IMHO not very nice.
>> When chpxchg is available also UML should use it...

On Tue, Apr 12, 2011 at 10:20 PM, Tejun Heo <tj@kernel.org> wrote:
> Ugh... I'd really like to avoid things like this for UML.  Is there
> any SLUB performance sensitive workload running on UML?  I've never
> seen any UML in production environment.  Wouldn't it be better to keep
> things simple?

Yes, it would be. :-)
