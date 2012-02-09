Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab2BIOe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:34:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43472 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2BIOe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:34:57 -0500
Date: Thu, 9 Feb 2012 12:34:49 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in
 record, stat, top
Message-ID: <20120209143449.GA2526@infradead.org>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <4F331F14.5070100@gmail.com>
 <4F3334F7.70809@gmail.com>
 <20120209073727.GA18152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209073727.GA18152@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 09, 2012 at 08:37:27AM +0100, Ingo Molnar escreveu:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > > I was trying to remove ctype.h, you might use util.h here.
> > 
> > Right, knew that. But, in this case I am adding a call to 
> > isdigit which means a direct dependency on ctype.h. I would 
> > prefer a direct relationship versus an indirect via util.h
> 
> Please just remove ctype.h *altogether* from perf, it's just an 
> insane header.
> 
> Have a look at how Git solves these types of problems, it 
> defines sane string functions in git-compat-util.h:

Yeah, these are in util.h, that doesn't includes ctype.h

I'm fixing this up and also that s/UUID/UID/g Kim pointed out,
then testing if the python binding still is ok with these changes.
 
> /* Sane ctype - no locale, and works with signed chars */
> #undef isascii
> #undef isspace
> #undef isdigit
> #undef isalpha
> #undef isalnum
> #undef tolower
> #undef toupper
> extern unsigned char sane_ctype[256];
> #define GIT_SPACE 0x01
> #define GIT_DIGIT 0x02
> #define GIT_ALPHA 0x04
> #define GIT_GLOB_SPECIAL 0x08
> #define GIT_REGEX_SPECIAL 0x10
> 
> Thanks,
> 
> 	Ingo
