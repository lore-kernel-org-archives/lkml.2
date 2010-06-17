Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0FQQdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:33:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58743 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0FQQdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kxIrD8cg8eH8ETF0iWGL8OmidhPJOSnTk/+q4NqsmuIIdzyWmsIw521np19QPbh0/b
         hD3BDmsrplJp7AcUi8VpUslO2tzcKVd16MCam65QjkQAVEjaBx2adQzyooqXqhpYXFRx
         gCIhu7qWvvHg1Aj6B3U0Ys93nlKaf7lecgn5Y=
Date: Thu, 17 Jun 2010 18:33:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100617163332.GB29824@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Jack Steiner <steiner@sgi.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617161728.GA2741@joi.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 06:17:28PM +0200, Marcin Slusarz wrote:
> On Thu, Jun 17, 2010 at 03:45:59PM +0200, Dan Carpenter wrote:
> > Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
> > error message in free_memtype() if rbt_memtype_erase() returns NULL.  
> > The problem is that if CONFIG_X86_PAT is enabled, we use a different
> > implimentation of rbt_memtype_erase() that always returns NULL.
> > 
> > I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and 
> > made free_memtype() check for that instead.
> > 
> > Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> This patch is probably ok, but it does not address my bug.
> I have CONFIG_X86_PAT=y, so rbt_memtype_erase does not always return NULL.
>  

Uh.  Yeah.  Crap.  I'm an idiot.

regrds,
dan carpenter


