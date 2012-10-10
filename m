Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2JJJCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:02:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54782 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2JJJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:02:37 -0400
Date: Wed, 10 Oct 2012 05:02:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jooyoung Hwang <jooyoung.hwang@samsung.com>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Message-ID: <20121010090228.GD11481@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jooyoung Hwang <jooyoung.hwang@samsung.com>,
	'Vyacheslav Dubeyko' <slava@dubeyko.com>,
	'Marco Stornelli' <marco.stornelli@gmail.com>,
	'Jaegeuk Kim' <jaegeuk.kim@gmail.com>,
	'Al Viro' <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, chur.lee@samsung.com,
	cm224.lee@samsung.com, linux-fsdevel@vger.kernel.org
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
 <1349553966.12699.132.camel@kjgkr>
 <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
 <1349812406.18456.41.camel@adg-desktop-09.cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349812406.18456.41.camel@adg-desktop-09.cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:53:26PM -0500, Jooyoung Hwang wrote:

> I'd like you to refer to the following link as well which is about
> mobile workload pattern.
> http://www.cs.cmu.edu/~fuyaoz/courses/15712/report.pdf
> It's reported that in Android there are frequent issues of fsync and
> most of them are only for small size of data.

What bothers me is no one is asking the question, *why* is Android
(and more specifically SQLite and the applications which call SQLite)
using fsync's so often?  These aren't transaction processing systems,
after all.  So there are two questions that are worth asking here.
(a) Is SQLite being as flash-friendly as possible, and (b) do the
applications really need as many transaction boundaries as they are
requesting of SQLite.

Yes, we can optimize the file system, but sometimes the best way to
optimize a write is to not to do the write at all (if it is not
required for the application's functionality, of course).  If the
application is requesting 4 transaction boundaries where only one is
required, we can try to make fsync's more efficient, yes --- but there
is only so much that can be done at the fs layer.

							- Ted
