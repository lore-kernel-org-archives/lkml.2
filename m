Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1AERbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:31:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1AERbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:31:10 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=u6Hy-5VoOc4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=fVoC8WWAWOJ_WNFWMskA:9 a=MhC0-nefE4iarheYx4QA:7 a=06BbM7n3B77P54INWtwwnmCulhQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] jump label: make enable/disable o(1)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <94bc7e748f6de41466c742b18cf4e09a34f82d69.1294239591.git.jbaron@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <94bc7e748f6de41466c742b18cf4e09a34f82d69.1294239591.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 12:31:05 -0500
Message-ID: <1294248665.26623.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 10:43 -0500, Jason Baron wrote:
>  
> +struct jump_label_key {
> +	int state;
> +};
> +
>  #define JUMP_LABEL(key, label)			\
>  do {						\
> -	if (unlikely(*key))			\
> +	if (unlikely(((struct jump_label_key *)key)->state))		\
>  		goto label;			\
>  } while (0)

Anything that uses JUMP_LABEL() should pass in a pointer to a struct
jump_label_key. Hence, remove the typecast. That can only lead to hard
to find bugs.

-- Steve


