Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0KUPxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:53:07 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35968 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754156Ab0KUPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:53:05 -0500
Date: Sun, 21 Nov 2010 09:52:52 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Handle DT_UNKNOWN on filesystems that don't
 support d_type
Message-ID: <20101121155252.GA2527@BohrerMBP>
References: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com>
 <20101121004836.GA16668@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121004836.GA16668@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 10:48:36PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Sat, Nov 20, 2010 at 06:42:19PM -0600, Shawn Bohrer escreveu:
> > Some filesystems like xfs and reiserfs will return DT_UNKNOWN for the
> > d_type.  Handle this case by calling stat() to determine the type.
> 
> Thanks for the fix, just waiting for some more reviewers to chime in,
> seems odd, like readdir_r has a bug.

The readdir_r man page says the following:

       If  the  file type could not be determined, the value DT_UNKNOWN
       is returned in d_type.

       Currently, only some file  systems  (among  them:  Btrfs,  ext2,
       ext3,  and  ext4)  have  full support returning the file type in
       d_type.  All applications  must  properly  handle  a  return  of
       DT_UNKNOWN.

So it isn't a bug in readdir_r.  This also isn't the only place that
perf uses readdir/readdir_r, and doesn't handle DT_UNKNOWN. In the
other locations it looked to me like it was only reading from debugfs,
so I don't think it matters.

> Even if that is the case we'll have to cope, and doing the extra stat
> only when in "doubt" (i.e. when getting DT_UNKNOWN) seems the right
> thing to me.
> 
> - Arnaldo
