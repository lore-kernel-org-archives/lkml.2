Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2CBOAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:00:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21491 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2CBOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:00:44 -0500
Date: Fri, 2 Mar 2012 09:00:38 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120302140038.GD5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F50D28A.00A5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
> 
> I've took both on tests. The subject is acp and spd_readdir used with
> tar, all on ext4:
> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
> 
> The acp looks much better than spd_readdir but directory copy with
> spd_readdir decreased to 52m 39sec (30 min less).

Do you have stats on how big these files are, and how fragmented they
are?  For acp and spd to give us this, I think something has gone wrong
at writeback time (creating individual fragmented files).

-chris

