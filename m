Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab0HDXcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:32:20 -0400
Received: from THUNK.ORG ([69.25.196.29]:58326 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0HDXcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:32:18 -0400
Date: Wed, 4 Aug 2010 19:32:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>,
        Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Message-ID: <20100804233206.GA2901@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Avi Kivity <avi@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C5818A1.9070102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5818A1.9070102@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 04:24:49PM +0300, Avi Kivity wrote:
>  On 06/30/2010 03:48 PM, tytso@mit.edu wrote:
> >
> >I wonder if it's worthwhile to think about a new system call which
> >allows users to provide an array of fd's which are collectively should
> >be fsync'ed out at the same time.  Otherwise, we end up issuing
> >multiple barrier operations in cases where the application needs to
> >do:
> >
> >	fsync(control_fd);
> >	fsync(data_fd);
> >
> 
> The system call exists, it's called io_submit().

Um, not the same thing at all.

						- Ted
