Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2DTKxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:53:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62686 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2DTKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:53:43 -0400
Date: Fri, 20 Apr 2012 07:53:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/13] perf annotate: Parse instruction
Message-ID: <20120420105349.GB9679@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
 <1334867644-2722-3-git-send-email-acme@infradead.org>
 <4F90A60D.6090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F90A60D.6090701@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 19, 2012 at 05:55:57PM -0600, David Ahern escreveu:
> On 4/19/12 2:33 PM, Arnaldo Carvalho de Melo wrote:
> >  		dl->offset = offset;
> >  		dl->line = strdup(line);
> >  		if (dl->line == NULL)
> >  			goto out_delete;
> >+
> >+		if (offset != -1) {
> >+			char *name = dl->line, tmp;
> >+
> >+			while (isspace(name[0]))
> >+				++name;
> >+
> >+			if (name[0] == '\0')
> >+				goto out_delete;
> >+
> >+			dl->operands = name + 1;
> >+
> >+			while (dl->operands[0] != '\0'&&
> >+			       !isspace(dl->operands[0]))
> >+				++dl->operands;
> >+
> >+			tmp = dl->operands[0];
> >+			dl->operands[0] = '\0';
> >+			dl->name = strdup(name);
> 
> This strdup seems unnecessary. The parsing seems to be:
> 
> dl->line = "\W*name\W*operands"
>    dl->name = -^    ^- = dl_operands
> 
> so name and operands are 2 different parts of the same buffer.

Yeah, but we still want to do searches in the whole line, sure we could
do that using the name + operands parts, but I got lazy at that point.

- Arnaldo
