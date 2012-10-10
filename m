Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2JJIFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 04:05:49 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33501 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752109Ab2JJIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 04:05:39 -0400
Message-ID: <1349856333.1889.92.camel@slavad-ubuntu>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Jooyoung Hwang <jooyoung.hwang@samsung.com>
Cc: "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        linux-fsdevel@vger.kernel.org
Date: Wed, 10 Oct 2012 12:05:33 +0400
In-Reply-To: <1349812406.18456.41.camel@adg-desktop-09.cs.wisc.edu>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
	 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
	 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
	 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
	 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
	 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
	 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
	 <1349812406.18456.41.camel@adg-desktop-09.cs.wisc.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.141.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 14:53 -0500, Jooyoung Hwang wrote:
> On Tue, 2012-10-09 at 16:08 +0900, Jaegeuk Kim wrote:
> > > -----Original Message-----
> > > From: Vyacheslav Dubeyko [mailto:slava@dubeyko.com]
> > > Sent: Tuesday, October 09, 2012 4:23 AM
> > > To: Jaegeuk Kim
> > > Cc: 'Marco Stornelli'; 'Jaegeuk Kim'; 'Al Viro'; tytso@mit.edu; gregkh@linuxfoundation.org; linux-
> > > kernel@vger.kernel.org; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com;
> > > linux-fsdevel@vger.kernel.org
> > > Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system

> 
> I'd like you to refer to the following link as well which is about
> mobile workload pattern.
> http://www.cs.cmu.edu/~fuyaoz/courses/15712/report.pdf
> It's reported that in Android there are frequent issues of fsync and
> most of them are only for small size of data.
> 
> To provide efficient fsync, F2FS minimizes the amount of metadata
> written to serve a fsync. Fsync in F2FS is completed by writing user
> data blocks and direct node blocks which point to them rather than
> creating a new checkpoint which would incur more I/O loads. 
> If sudden power failure happens, then F2FS recovery routine rolls back
> to the latest checkpoint and thereafter recovers file system state to
> reflect all the completed fsync operations, which we call roll-forward
> recovery.
> You may want to look at the code about the roll-forward in recover_fsync_data().
> 

Thank you.

With the best regards,
Vyacheslav Dubeyko.

> --
> Jooyoung Hwang
> Samsung Electronics
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


