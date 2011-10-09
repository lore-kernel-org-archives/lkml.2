Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1JID3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 23:29:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46436 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751413Ab1JID3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 23:29:36 -0400
Message-ID: <1318130976.1844.48.camel@Joe-Laptop>
Subject: Re: [PATCH 1/2 v3] udf : enable error print in udf_read_tagged().
From: Joe Perches <joe@perches.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Date: Sat, 08 Oct 2011 20:29:36 -0700
In-Reply-To: <CAKYAXd8M6mnf0f_5RHpkjZ51suGnnFTHU1ZuJgvt5Nr0JVR1RQ@mail.gmail.com>
References: <1317650037-4648-1-git-send-email-linkinjeon@gmail.com>
	 <20111005220813.GK23467@quack.suse.cz>
	 <1317853198.3095.19.camel@Joe-Laptop>
	 <20111006214159.GK31367@quack.suse.cz>
	 <CAKYAXd8M6mnf0f_5RHpkjZ51suGnnFTHU1ZuJgvt5Nr0JVR1RQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-09 at 12:16 +0900, NamJae Jeon wrote:
> 2011/10/7 Jan Kara <jack@suse.cz>:
> > On Wed 05-10-11 15:19:58, Joe Perches wrote:
> >> On Thu, 2011-10-06 at 00:08 +0200, Jan Kara wrote:
> >> > Hello,
> >> >
> >> > On Mon 03-10-11 22:53:57, Namjae Jeon wrote:
> >> > > While reading metadata, if a problem occurs, Print out only one of the
> >> > > five case.(It also does not show a checksum properly.) Because currently
> >> > > it have been disable by undef udf_debug.  If there is a problem with
> >> > > scratched disc or loader, the user needs to know which error happened.
> >> > > And I use pr_fmt instead of printk by joe's suggestion. I try to modify
> >> > > totally it to pr_fmt also.
> >>
> >> >   Thanks for the patch. I'm willing to take the patch since it's an
> >> > improvement but what would be even nicer is to have error reporting like in
> >> > ext3 / ext4. We would have functions udf_info, udf_warn, udf_err which
> >> > also print sb->s_id with each error so that user can better identify on
> >> > which filesystem error happened.
> >>
> >> Modifying the follow-on patch I sent would be pretty trivial.
> >  Sure, I can do that but if Namjae is willing to do it, I'd have less work
> > :).
> Hi. Jan.
> 
> Currently I can not send a patch using git send-email.
> maybe it is the problem related with git or patch size...
> So I attach a patch. Is it okay? or I resend a patch again..
> plz review attach patch.
> Thanks.

Not a good patch I think.

You've broken format strings when they should be coalesced
and the alignment looks odd.

udf_debug should also add
	struct super_block *sb, const char *function,
as the leading arguments.

