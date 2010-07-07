Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0GGRVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:21:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59229 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab0GGRVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:21:02 -0400
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
From: john stultz <johnstul@us.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       oleg@redhat.com
In-Reply-To: <20100707171103.GB20533@jolsa.brq.redhat.com>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
	 <AANLkTilE3sd7SSLVCN87rpJ5iSm-sYd-n6nJnzlByfRK@mail.gmail.com>
	 <1278457900.1715.9.camel@localhost>
	 <20100707171103.GB20533@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 10:20:30 -0700
Message-ID: <1278523230.2635.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 19:11 +0200, Jiri Olsa wrote:
> On Tue, Jul 06, 2010 at 04:11:40PM -0700, john stultz wrote:
> > -	vgettimeofday(&tv, NULL);
> > -	result = tv.tv_sec;
> > +	do {
> > +		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
> > +
> > +		result = vsyscall_gtod_data.wall_time_sec;
> > +
> > +	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
> > +
> >  	if (t)
> >  		*t = result;
> >  	return result;
> > 
> > 
> 
> I think there's a typo in using "vsyscall_gtod_data" inside
> the vtime call it should be "__vsyscall_gtod_data" intead.

Quite right! Thanks for catching it!
-john


