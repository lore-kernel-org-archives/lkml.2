Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0DZAqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 20:46:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:38802 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab0DZAqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 20:46:04 -0400
Date: Sun, 25 Apr 2010 20:45:58 -0400
From: tytso@mit.edu
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
Message-ID: <20100426004558.GA13043@thunk.org>
Mail-Followup-To: tytso@mit.edu, Randy Dunlap <randy.dunlap@oracle.com>,
	Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Len Brown <len.brown@intel.com>
References: <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
 <1271984938-13920-5-git-send-email-arve@android.com>
 <1271984938-13920-6-git-send-email-arve@android.com>
 <20100423135853.478af057.randy.dunlap@oracle.com>
 <20100425181517.GA22676@kroah.com>
 <4BD49D9D.7020004@oracle.com>
 <20100426000025.GE667@thunk.org>
 <4BD4DCEA.8060602@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD4DCEA.8060602@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 05:23:06PM -0700, Randy Dunlap wrote:
> Yeah, I think that it should be in procfs.  It's not strictly closed
> to new files.  (IOW, I'm sure that we can find a bunch of recent files
> added to procfs.)

That's reasonable (I think the whole /proc is evil crusade is really
dumb) --- but at the same time, remember how frustrating it is for the
poor embedded developer who doesn't know who to ignore and what
"rules" to ignore.  They were told months ago /proc is evil, and so
they moved it to /debugfs, precisely because it was billed as "it has
no rules".  For all I know some helpful community developer may have
even suggested that to them.

It is extremely frustrating to embedded developers when they get
conflicting advice, especially in this case, when it was *in* /proc in
the first place.  I'm not sure what to do about this --- my approach
is to sometimes say, "f*ck it, that's stupid advice", and ship it to
Linus, who tends to be *much* less of a pendant than most of the
people who review code --- but that's because I know what I can
ignore.  (I seriously doubt Linus cares much about whether it ends up
the file ends up /debugfs or /proc, and would take the code either
way.)  But for someone who doesn't understand when you can do this,
and who tries to follow every single piece of criticism they get, the
end result can often be a huge amount fo wasted time and frustration.

It would be nice if we could get better at this, since I'm sure this
is not the only time when embedded code submissions have gotten what
the submitting developers might consider to be a runaround....

(And just to be clear, I'm not criticising your commends; my personal
preference is slightly in favor of /proc, but more than anythign else,
I consider it a very minor point.  I just want to point out that they
_started_ with the file in /proc and changed it to /debugfs based on
someone NACK'ing their patch, with a "/proc, eeeeewwww" comment.
Sometimes I think some code reviewers get too much of a sense of power
trip by thinking they can NACK other people's code over their own pet
peeves.... instead of approaching it from a somewhat more collegial
point of view trying to make the code better.  Present company
excepted, of course.  :-)

		       	      	     	     - Ted
