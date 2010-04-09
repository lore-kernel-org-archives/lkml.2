Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0DIXeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:34:06 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:44873 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0DIXeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=brsiE6lgIy1eGGYZfQimUn4+43CKfG1jciId0CMbmLXszt2bfDVC0HXnuem2NPIP1f
         fBk5UQixzXw09RcjdmAYffqhuFMGd+uxoApVloqBCB5F1ASqLkVkrSID5sneDOvf5kos
         wLq3nbF2ScA4VjDmfz4ZiYR1R7vACT6+GoQ64=
MIME-Version: 1.0
Date: Fri, 9 Apr 2010 19:34:00 -0400
X-Google-Sender-Auth: fe813fc87f58471e
Message-ID: <z2md05829401004091634jbb41b5ej9defeb0185929845@mail.gmail.com>
Subject: bt878/msp3445 Audio Channel Swapping
From: Paul Braman <bramankp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is something that just "everyone already knows" but I can't
find documentation about it.  In several kernels I've tried, most
recently 2.6.30, the drivers for NTSC tuner cards with AV inputs have
their left-right channels swapping coming out of the ALSA drivers.
Both the RF and AV inputs are like this.  However, with the
bt878/msp3445 combination, switching back and forth from RF and AV can
actually induce swapping channels *back* to their original assignments
(and back and forth, etc, upon source switching).

The best we've been able to figure, the drivers or the hardware is
dropping samples so the stereo interleaving is getting reversed.  It
only happens when the audio mux is mutated to a different
configuration but it's not deterministic so it's very hard to track,
for example, true stereo left/right.  Is this just a known problem
that everyone deals with?


Paul Braman
Lead Software Engineer
The Nielsen Company
