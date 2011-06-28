Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573Ab1F1RuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:50:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64222 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab1F1Rs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110628145404.GD2472@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-9-git-send-email-jim.cromie@gmail.com> <BANLkTikpuHNBU5yJwwxsPLmdPyG1TNj97Q@mail.gmail.com>
 <20110628145404.GD2472@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Jun 2011 19:48:07 +0200
X-Google-Sender-Auth: DnWfDg1yr5CxTDhDpCPYG8cUTUk
Message-ID: <BANLkTin4Sp6rw25WffuEXeEQhJBiCzmiTQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] dynamic_debug: return int from ddebug_change
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gnb@fmeh.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:54 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Tue, Jun 28, 2011 at 12:24:56PM +0200, Bart Van Assche wrote:
> > On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > > @@ -425,6 +424,7 @@ static int ddebug_exec_query(char *query_string)
> > >  #define MAXWORDS 9
> > >        int nwords;
> > >        char *words[MAXWORDS];
> > > +       int nfound;
> > >
> > >        nwords = ddebug_tokenize(query_string, words, MAXWORDS);
> > >        if (nwords <= 0)
> > > @@ -435,7 +435,8 @@ static int ddebug_exec_query(char *query_string)
> > >                return -EINVAL;
> > >
> > >        /* actually go and implement the change */
> > > -       ddebug_change(&query, flags, mask);
> > > +       nfound = ddebug_change(&query, flags, mask);
> > > +
> > >        return 0;
> >
> > Do these changes actually do anything, or did I miss something ?
>
> its used in a subsequent patch to decide whether or not to call
> add_to_pending.

As far as I can see your comment applies to the function
ddebug_change() while my comment applies to the function
ddebug_exec_query(). If you have a close look at the above changes you
will see that these do nothing more than adding a dead assignment.

Bart.
