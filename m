Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1GCIY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:24:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57808 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1GCIYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinwwaD=O2nFEN8G+U2eWBPMUM9Ovg@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-10-git-send-email-jim.cromie@gmail.com> <BANLkTinwwaD=O2nFEN8G+U2eWBPMUM9Ovg@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 3 Jul 2011 10:24:33 +0200
X-Google-Sender-Auth: QL63pwoRy5QEwbVYdB0nGvQKHeI
Message-ID: <CAO+b5-pFz6HXBLu1eED4R+M=Zykkrri9uDu-iHw_soC4ZTJkbA@mail.gmail.com>
Subject: Re: [PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching
 queries for later.
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:17 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Tue, Jun 28, 2011 at 1:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> +static char prbuf_query[300];
>> +
>> +static char *show_ddebug_query(const struct ddebug_query *q)
>> +{
>
>
> this part (the static fixed-length var)
> gives me some heartburn.
>
> I almost went with macros using pr_info to replace the
>  2 show_*_query fns, but a <debugfs/dynamic_debug/pending file
> might want to use show_pending_query
>
> advice ?

How about using kasprintf() inside show_ddebug_query() and let the
show_ddebug_query() free the buffer that has been allocated by
kasprintf() ?

Bart.
