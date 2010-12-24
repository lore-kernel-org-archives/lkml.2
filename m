Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0LXNOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:14:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33723 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0LXNOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=ctwzZRRXkszh27IHQjVcCsNMUUOUJ5S7pykitgbLh+a0i7JND41D6NjrQdrqnZ1Qjy
         cBc8Ciwawttq7Q47mJ187KJPVv0f/dhyeAXR3yjJS3P/c9Q+PdVZAF8bH+baSWUqhD06
         Af/D2+1YaEDdd0wn+EgcLbCtbSpSNXpQkCRyo=
Date: Fri, 24 Dec 2010 11:14:41 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: no need to initialize the entire temporary
 buffers in synthesize_perf_probe_point()
Message-ID: <20101224131441.GA3128@ghostprotocols.net>
References: <m3wrn07blu.fsf@gmail.com>
 <4D142591.2030101@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D142591.2030101@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 24, 2010 at 01:46:09PM +0900, Masami Hiramatsu escreveu:
> (2010/12/24 0:27), Franck Bui-Huu wrote:
> > This patches only put a single null byte at the beginning of each
> > temporary buffers line[], offs[], file[] instead of filling their
> > full contents with null bytes.

> Hmm, sorry but NAK it.

> IMHO, with modern chips, the original code has no problem from the
> viewpoint of memory access (all are cached and no need to access just
> one byte) nor a bottleneck.
> I'd rather use '= ""' style initialization for local variables from the
> viewpoint of readability.

No strong feelings here, not really a fast path, just learned something
new, I thought that that kind of initialization would be equivalent to
what Franck proposed, but gcc really uses the most efficient way of
zeroing the whole string (movq for things like that, and rep stos for
bigger arrays, etc).
 
> Anyway, thank you for looking into the code :-)

Yes, please continue sending your improvements and fixes!

Masami, what about the fixes Franck sent, clould you please send ACK or
NACKs for those?

- Arnaldo
