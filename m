Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1FRKkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 06:40:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42987 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1FRKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 06:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=P+bK5ZuTvl6DBDwJqbFYphsZNnld2zAdRZ8icCrekQI4Aa2PUlB6s6WFKr8tc4Hy5W
         Er8Nw3oMILril0Dl7pbq7a/vOWO+kkUBMFMsUgJ/TVy2TQ9cbwAlUSaEynQ0obMFQIea
         7vlDqyxoCjRFdn1cmqykKDxJEGruE47QPw2zA=
Date: Sat, 18 Jun 2011 13:39:57 +0300
From: Pekka Paalanen <pq@iki.fi>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS:
 Faking MMIO ops? Fooling a driver]
Message-ID: <20110618133957.378b5266@farn.lan>
In-Reply-To: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011 00:31:32 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> I use attached patch to fake result of read[bwl] performed by
> closed source driver (ndiswrapper+bcmwl and wl).
> 
> 1) It works great on my Sony VAIO with Intel(R) Core(TM)2 Duo CPU
> P8400 2) It locks up Macbook Pro 8,1 with some 8-cores Intel
> 
> Do you have any idea why it causes the lockup? Function causing
> problem is "set_ins_reg_val". I've created it as copy of
> get_ins_reg_val, it just sets values in struct pt_regs, instead of
> reading them).

Sorry, I have no insight to that... does unmodified mmiotrace
work properly? Are you tracing the exact same kernel binary blob
on both machines? Maybe it's using some rare instruction
mmiotrace does not decode properly? Maybe with a rep prefix?
Do those CPUs have any differences in their registers or
struct pt_regs?

I'm not even sure how "legal" it is to poke pt_regs there. :-/


Good luck.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
