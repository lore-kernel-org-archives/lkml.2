Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0LIRJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:09:36 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39702 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0LIRJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TwOMSFVkUGGXSMN2qF/b37J1BA6aNaBUCkPEFDcLSlxu8iIlmmzf/Y0k/Uj8x9iixM
         WkB7ipMG6mmBvH7ATaisecR7LAFwfrt4YvdPZt3NBsoqQLn1dIWyza8qVqlEBHYKHebp
         Up0fP5pXGWvKudUKlycemQAGLd8xdFBA6Xkck=
Subject: Re: [regression, 2.6.37-rc1] 'ip link tap0 up' stuck in do_exit()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Florian Mickler <florian@mickler.org>,
        Ingo Molnar <mingo@elte.hu>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1291914474.4063.68.camel@edumazet-laptop>
References: <20101103062609.GB31163@dastard>
	 <1288768402.2467.665.camel@edumazet-laptop> <20101103103448.GA9169@dastard>
	 <20101103112936.GB9169@dastard> <20101104002140.GA13830@dastard>
	 <20101104054718.GC5210@cr0.nay.redhat.com>
	 <20101208100245.01cf23c5@schatten.dmk.lab>
	 <20101208134116.GA16923@redhat.com> <20101208134712.GB16923@redhat.com>
	 <20101208140822.GA18681@redhat.com>  <20101209164748.GA3218@hack>
	 <1291914474.4063.68.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 18:09:29 +0100
Message-ID: <1291914569.4063.72.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 décembre 2010 à 18:07 +0100, Eric Dumazet a écrit :
> Le vendredi 10 décembre 2010 à 00:47 +0800, Américo Wang a écrit :
> 
> > Yeah, there is no point that a zombie can trigger a BUG_ON in kenrel.
> > But it is still interesting to know why it becomes a zombie...
> > 
> 
> A zombie is very easy to get.
> 
> Technically speaking, all processes die and become zombies, unless
> parent said : signal(SIGCLD, SIG_IGN) before fork()
> 
> The parent is buggy (sudo in this case ?) and doesnt call wait() to
> 'free' one of its children.
> 
> 

Before you ask :)

If the parent dies before the child, task is re-parented to init.

Then, with namespaces, I dont know what happens (is there one init per
namespace ?)




