Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0ETO34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:29:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0ETO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:29:55 -0400
Date: Thu, 20 May 2010 11:29:31 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt build
 ids
Message-ID: <20100520142931.GC26284@ghostprotocols.net>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
 <AANLkTin1Lof5-907Afc24Ato1MqOE93uyxb-xx4XEYUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1Lof5-907Afc24Ato1MqOE93uyxb-xx4XEYUg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 20, 2010 at 11:54:17AM +0200, Stephane Eranian escreveu:
> Arnaldo,
> 
> On Wed, May 19, 2010 at 7:01 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > [root@doppio linux-2.6-tip]#
> > [root@doppio linux-2.6-tip]# perf archive
> > Now please run:
> >
> > $ tar xvf perf.data.tar.bz2 -C ~/.debug
> >
> > wherever you need to run 'perf report' on.
> 
> Supposedly, on the remote machine with the perf.data +tarball files,
> I should be able to run perf report, perf annotate.
> 
> I tried that. The perf report works but not perf annotate. It can't
> find the binary image of my program. Yet there is a copy in the
> .debug subdir. It seems, it is looking for the image using the
> absolute file path in perf.data, instead.
> 
> Am I missing something here?

No, you are not, annotate should look by build-id, then pass this to
objdump, lemme cook a patch.

- Arnaldo
