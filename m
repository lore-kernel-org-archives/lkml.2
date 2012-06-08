Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab2FHCWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760089Ab2FHCWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:22:49 -0400
Date: Thu, 7 Jun 2012 22:22:41 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
Message-ID: <20120608022240.GC7191@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Oleg Nesterov <oleg@redhat.com>
References: <20120608002451.GA821@redhat.com>
 <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
 <20120607180515.4afffc89.akpm@linux-foundation.org>
 <CA+55aFz12eeNHGt5GV_w=brPVed3Ga9HjYy73dbusEyPpX39OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFz12eeNHGt5GV_w=brPVed3Ga9HjYy73dbusEyPpX39OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 06:09:20PM -0700, Linus Torvalds wrote:
 > On Thu, Jun 7, 2012 at 6:05 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
 > >
 > > It appears this is due to me fat-fingering conflict resolution last
 > > week.  That hunk is supposed to be in mm_release(), not mmput().
 > 
 > Ahh. That would indeed make more sense. The mmput() placement is
 > insane for so many reasons.
 > 
 > I reverted it and pushed it out, because it clearly was horrible. Even
 > if it is possible that Dave's problems are due to something else (but
 > if they started with the mm merge, I don't see anything else nearly as
 > scary in there)

Spooky. With that reverted, I don't see those weird oopses any more,
even with the potentially suspect 8169 tracing patch reapplied. So uh, I dunno.

	Dave

