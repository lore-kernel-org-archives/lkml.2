Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2JJLxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:53:05 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:55114 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2JJLxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:53:01 -0400
Message-ID: <50756199.1090103@ladisch.de>
Date: Wed, 10 Oct 2012 13:52:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Jooyoung Hwang <jooyoung.hwang@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, linux-fsdevel@vger.kernel.org
CC: sqlite-users@sqlite.org
Subject: Re: SQLite on flash (was: [PATCH 00/16] f2fs: introduce flash-friendly
 file system)
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com> <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com> <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com> <002201cda46e$88b84d30$9a28e790$%kim@samsung.com> <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com> <004101cda52e$72210e20$56632a60$%kim@samsung.com> <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com> <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com> <1349812406.18456.41.camel@adg-desktop-09.cs.wisc.edu> <20121010090228.GD11481@thunk.org>
In-Reply-To: <20121010090228.GD11481@thunk.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'd sqlite-users ML)
Theodore Ts'o wrote:
> On Tue, Oct 09, 2012 at 02:53:26PM -0500, Jooyoung Hwang wrote:
>> I'd like you to refer to the following link as well which is about
>> mobile workload pattern.
>> http://www.cs.cmu.edu/~fuyaoz/courses/15712/report.pdf
>> It's reported that in Android there are frequent issues of fsync and
>> most of them are only for small size of data.
>
> What bothers me is no one is asking the question, *why* is Android
> (and more specifically SQLite and the applications which call SQLite)
> using fsync's so often?  These aren't transaction processing systems,
> after all.

Neither were Firefox's bookmarks and history.  That one got fixed,
but it was a single application.

> So there are two questions that are worth asking here.
> (a) Is SQLite being as flash-friendly as possible,

It would be possible to use the write-ahead log instead of the default
rollback journal, but that is unfortunately not entirely compatible --
HTC once enabled WAL by default on some phones, and all apps that tried
to open a database in read-only mode broke.  If apps are aware of this,
they can enable WAL for their own DBs without problems.

There are some other configuration options, but they, too, have side
effects and thus cannot be enabled by default.

SQLite 4 (currently being developed) will use a log-structured merge
database.

> and (b) do the applications really need as many transaction boundaries
> as they are requesting of SQLite.

Most apps get the default of one transaction per statement because they
do not bother to mange transactions explicitly.


Regards,
Clemens
