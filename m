Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2B2OoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:44:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22686 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2B2OoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:44:10 -0500
Date: Wed, 29 Feb 2012 09:42:44 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        lczerner@redhat.com
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120229144244.GF5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
 <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F4E39B6.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 03:07:45PM +0100, Jacek Luczak wrote:

[ btrfs faster than ext for find and cp -a ]

> 2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
> 
> I will try to answer the question from the broken email I've sent.
> 
> @Lukas, it was always a fresh FS on top of LVM logical volume. I've
> been cleaning cache/remounting to sync all data before (re)doing
> tests.

The next step is to get cp -a out of the picture, in this case you're
benchmarking both the read speed and the write speed (what are you
copying to btw?).

Using tar cf /dev/zero <some_dir> is one way to get a consistent picture
of the read speed.

You can confirm the theory that it is directory order causing problems
by using acp to read the data.

http://oss.oracle.com/~mason/acp/acp-0.6.tar.bz2

-chris

