Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0KUPyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:54:39 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:50751 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754245Ab0KUPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:54:38 -0500
Date: Sun, 21 Nov 2010 09:54:33 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Handle DT_UNKNOWN on filesystems that don't
 support d_type
Message-ID: <20101121155433.GB2527@BohrerMBP>
References: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com>
 <m2ipzryoz2.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ipzryoz2.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:01:53AM +0100, Andreas Schwab wrote:
> Shawn Bohrer <sbohrer@rgmadvisors.com> writes:
> 
> > +		if (((lang_dirent.d_type == DT_DIR &&			\
> > +		      lang_dirent.d_type != DT_UNKNOWN) ||		\
> > +		     (lang_dirent.d_type == DT_UNKNOWN &&		\
> > +		      is_directory(scripts_path, &lang_dirent))) &&	\
> 
> 		if ((lang_dirent.d_type == DT_DIR ||			\
> 		     (lang_dirent.d_type == DT_UNKNOWN &&		\
> 		      is_directory(scripts_path, &lang_dirent))) &&	\
> 
> > +		if ((script_dirent.d_type != DT_DIR &&			\
> > +		     script_dirent.d_type != DT_UNKNOWN) ||		\
> > +		    (script_dirent.d_type == DT_UNKNOWN &&		\
> > +		     !is_directory(lang_path, &script_dirent)))
> 
> 		if (script_dirent.d_type != DT_DIR &&			\
> 		    (script_dirent.d_type != DT_UNKNOWN ||		\
> 		     !is_directory(lang_path, &script_dirent)))
> 
> (DeMorgan: !(a && b) <-> (!a || !b); !(a || b) <-> (!a && !b))

Thanks Andreas, I'll send a follow up patch with the cleanup.

--
Shawn
