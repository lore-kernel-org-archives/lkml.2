Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2JQDoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:44:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30998 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:44:15 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-1d-507e298db717
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <201210151405.41392.arnd@arndb.de>
 <015a01cdab46$145caa10$3d15fe30$%kim@samsung.com>
 <201210161614.15636.arnd@arndb.de> <1350423780.1958.86.camel@kjgkr>
In-reply-to: <1350423780.1958.86.camel@kjgkr>
Subject: RE: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 12:44:12 +0900
Message-id: <021601cdac19$ac462350$04d269f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2r5zw86n1l7KMgSE2FEXmIQafn9QAMB59g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd1ezboAgwcLBS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3y+7mQs6lCtOLX3F3MB4SqqLkZNDQsBE4trkHSwQtpjEhXvr
	2boYuTiEBBYxShy+uIcdJCEkMJ9Jon++QxcjBwebgLbE5v0GIGERAWWJ4y/vsIDUMwtMZ5JY
	8nURVPMdRomJfx8xglRxCuhKnD27DGyDsICHxLWvG8CGsgioSmy5NJMVxOYVsJU433aWCcIW
	lPgx+R4LyDJmAXWJKVNyQcLMQHufvLvAChKWAAo/+qsLcYORxIqF65ghSkQk9r14xziBUWgW
	kkGzEAbNQjJoFpKOBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCg/iZ1A7GlQ0WhxgF
	OBiVeHg/zK4NEGJNLCuuzD3EKMHBrCTCa94IFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JES
	ICSQnliSmp2aWpBaBJNl4uCUamDc8KOlkynTm3GuQJfDkZCTDXrrH78/0sVjelz2wMkW2e8f
	3p5oydBkFi9z8G848e6J073Nr7fV6k3l2m600yaf/bGXz913qctETpnLuEg19v25oCpz133P
	ndrJCvPOP1SJXRs592qe+tqoO2uMNt2W0r5+e928TQpxdcvu6/Zv9VnxMfaalsVbJZbijERD
	Leai4kQAI/kq2F4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012-10-16 (화), 16:14 +0000, Arnd Bergmann:
> > On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > > Thank you for a lot of points to be addressed. :)
> > > Maybe it's time to summarize them.
> > > Please let me know what I misunderstood.
> > >
> > > [In v2]
> > > - Extension list
> > >   : Mkfs supports configuring extensions by user, and that information
> > >     will be stored in the superblock. In order to reduce the cleaning overhead,
> > >     f2fs supports an additional interface, ioctl, likewise ext4.
> >
> > That is what I suggested but actually Dave Chinner is the person that you
> > need to listen to rather than me in this regard. Using an extended attribute
> > in the root node would be more appropriate to configure this than an ioctl.
> >
> > > - The number of active logs
> > >   : No change will be done in on-disk layout (i.e., max 6 logs).
> > >     Instead, f2fs supports changing the number with a mount option.
> > >     Currently, I think 4, 5, and 6 would be enough.
> >
> > Right, that would be the minimum that I would ask for. If it is relatively
> > easy to support more than six logs in the file format without actually
> > implementing them in the code, you might want to support up to 16, just
> > to be future-proof.
> 
> Ok, got it.
> 
> >
> > For the lower bound, being able to support as little as 2 logs for
> > cheap hardware would be nice, but 4 logs is the important one.
> >
> > 5 logs is probably not all that important, as long as you have the
> > choice between 4 and 6. If you implement three different ways, I
> > would prefer have the choice of 2/4/6 over 4/5/6 logs.
> 
> Ok, I'll try, but in the case of 2 logs, it may need to change recovery
> routines.
> 
> >
> > > - Section size
> > >   : Mkfs supports multiples of segments for a section, not power-of-two.
> >
> > Right.
> >
> > > [Future optimization]
> > > - Data separation
> > >   : file access pattern, and else?
> >
> >  : Investigate the option to make large files erase block indirect rather than
> >    part of the normal logs
> >
> > There is one more more point that I have not mentioned before, which is the
> > alignment of write requests. As far as I can tell, you try to group writes
> > as much as possible, but the alignment and the minimum size is still just
> > 4 KB.
> 
> Yes.
> 
> > I fear that this might not be good enough for a lot of cases when
> > the page sizes grow and there is no sufficient amount of nonvolatile
> > write cache in the device. I wonder whether there is something that can
> > be done to ensure we always write with a minimum alignment, and pad
> > out the data with zeroes if necessary in order to avoid getting into
> > garbage collection on devices that can't handle sub-page writes.
> 
> You're very familiar with flash. :)
> Yes, as the page size grows, the sub-page write issue is one of the
> most critical problems.
> I also thought this before, but I have not made a conclusion until now.
> Because, I don't know how to deal with this in other companies, but,
> I've seen that so many firmware developers in samsung have tried to
> reduce this overhead by adapting many schemes.
> I guess very cautiously that other companies also handle this well.
> Therefore, I keep a question whether file system should care about
> this perfectly or not.
> 
> Thanks,
> 
> >
> > 	Arnd
> 

As discussed with Dave, I propose the following items.

[In v2]
- Extension list
   : Mkfs supports configuring extensions by user, and that information
     will be stored in the superblock.
     I'll add a mount option to enable/disable using the extension list.
     Instead, f2fs supports xattr to give a hint to any files.
     After supporting this by VFS, it'll be removed.
- The number of active logs
  : For compatibility, on-disk layout supports max 16 logs.
    Instead, f2fs supports configuring the number of active logs that
    will be used by a mount option.
    The option supports 2, 4, and 6 logs.
- Section size
  : Mkfs supports multiples of segments for a section, not power-of-two.

[Future optimization]
- Data separation
  : file access pattern
  : Investigate the option to make large files erase block indirect rather than
   part of the normal logs
  : sub-page write avoidance

Thanks,

> --
> Jaegeuk Kim
> Samsung

