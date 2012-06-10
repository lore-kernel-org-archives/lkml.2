Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2FJCPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:15:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FJCPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:15:47 -0400
Date: Sat, 9 Jun 2012 19:15:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
In-Reply-To: <alpine.LFD.2.02.1206082232570.3086@ionos>
Message-ID: <alpine.DEB.2.00.1206091914560.7832@chino.kir.corp.google.com>
References: <20120604152710.GA1710@redhat.com> <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com> <20120605174454.GA23867@redhat.com> <20120605185239.GA28172@redhat.com> <alpine.DEB.2.00.1206081256330.19054@chino.kir.corp.google.com>
 <alpine.LFD.2.02.1206082232570.3086@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Thomas Gleixner wrote:

> > If we're leaking task_struct's, meaning that put_task_struct() isn't 
> > actually freeing them when the refcount goes to 0, then it's certainly not 
> > because of the oom killer which only sends a SIGKILL to the selected 
> > process.
> 
> I rather suspect, that this is a asymetry between get_ and
> put_task_struct and refcount just doesn't go to zero.
> 

We found an actual task_struct leak within put_task_struct() because of 
the free task notifiers during the 3.4 -rc cycle, so if kmemleak doesn't 
show anything then would it be possible to bisect the problem Dave?
