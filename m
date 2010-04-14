Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0DNAlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:41:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54809 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0DNAlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dx2APfyvxrFoNX/8R6kxMlIwTxv7jtPqqeVi13yzsMS8jxtZcS0PzDzL7jziJFAM09
         T71LEZXug+DSi2Mt8Kg5+07O2BjWrBGPyG9z4xPkb+sVZlmPHb9+3IDAK6aRY4Pbu7TZ
         fVT+f0J3/O7pjyxi6JjPnCa1CuGnGgJFjpCSA=
Date: Wed, 14 Apr 2010 02:41:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: Fix accidentally preprocessed snprintf callback
Message-ID: <20100414004115.GI5602@nowhere>
References: <1271205468-8202-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271205468-8202-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 02:37:48AM +0200, Frederic Weisbecker wrote:
> struct sort_entry has a callback named snprintf that turns an
> entry into a string result.
> 
> But there are glibc versions that implement snprintf through a
> macro. The following expression is then going to get the snprintf
> call preprocessed:
> 
> 	ent->snprintf(...)
> 
> to finally end up in a build error:
> 
> 	util/hist.c: Dans la fonction «hist_entry__snprintf» :
> 	util/hist.c:539: erreur: «struct sort_entry» has no member named «__builtin___snprintf_chk»
> 
> To fix this, rename struct sort_entry::snprintf() callback to
> to_string(), assuming at least Java methods naming won't ever
> conflict with perf.


Note I'm not entirely happy with this to_string() renaming.
May be append_string() would have been better. I don't know.
snprintf() was just too good.
If you think about something else, don't hesistate to change,
or I can change it myself if you want.

Thanks.

