Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab1F1Ozg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab1F1OyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:54:11 -0400
Date: Tue, 28 Jun 2011 10:54:05 -0400
From: Jason Baron <jbaron@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gnb@fmeh.org, gregkh@suse.de
Subject: Re: [PATCH 08/11] dynamic_debug: return int from ddebug_change
Message-ID: <20110628145404.GD2472@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-9-git-send-email-jim.cromie@gmail.com>
 <BANLkTikpuHNBU5yJwwxsPLmdPyG1TNj97Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikpuHNBU5yJwwxsPLmdPyG1TNj97Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:24:56PM +0200, Bart Van Assche wrote:
> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > @@ -425,6 +424,7 @@ static int ddebug_exec_query(char *query_string)
> >  #define MAXWORDS 9
> >        int nwords;
> >        char *words[MAXWORDS];
> > +       int nfound;
> >
> >        nwords = ddebug_tokenize(query_string, words, MAXWORDS);
> >        if (nwords <= 0)
> > @@ -435,7 +435,8 @@ static int ddebug_exec_query(char *query_string)
> >                return -EINVAL;
> >
> >        /* actually go and implement the change */
> > -       ddebug_change(&query, flags, mask);
> > +       nfound = ddebug_change(&query, flags, mask);
> > +
> >        return 0;
> 
> Do these changes actually do anything, or did I miss something ?
> 
> Bart.

its used in a subsequent patch to decide whether or not to call
add_to_pending.

thanks,

-Jason
