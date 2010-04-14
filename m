Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0DNRbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab0DNRbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:31:46 -0400
Date: Wed, 14 Apr 2010 14:31:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] perf: Fix accidentally preprocessed snprintf
	callback
Message-ID: <20100414173130.GJ25649@ghostprotocols.net>
References: <1271205468-8202-1-git-send-regression-fweisbec@gmail.com> <1271265089-1842-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271265089-1842-1-git-send-regression-fweisbec@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 14, 2010 at 07:11:29PM +0200, Frederic Weisbecker escreveu:
> struct sort_entry has a callback named snprintf that turns an
> entry into a string result.
> But there are glibc versions that implement snprintf through a
> macro. The following expression is then going to get the snprintf
> call preprocessed:
> 
>         ent->snprintf(...)
> 
> to finally end up in a build error:
> 
>         util/hist.c: Dans la fonction «hist_entry__snprintf» :
>         util/hist.c:539: erreur: «struct sort_entry» has no member named «__builtin___snprintf_chk»
> 
> To fix this, prepend struct sort_entry callbacks with an "se_"
> prefix.

Thanks, I'll queue this one up

- Arnaldo
