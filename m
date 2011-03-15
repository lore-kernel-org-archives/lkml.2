Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab1COMLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:11:54 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:37995 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab1COMLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:11:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in, __mark_inode_dirty
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <4D7F3CD5.9030105@secunet.com>
Date: Tue, 15 Mar 2011 12:11:42 +0000
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Andreas_Bie=DFmann?= <biessmann@corscience.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <99773600-FC41-41A9-8544-BF7E09065546@cam.ac.uk>
References: <fa.8ND6HoGS9dKYUuniFCAoNq+1TFY@ifi.uio.no> <4D78AA72.3060202@secunet.com> <4D7F3CD5.9030105@secunet.com>
To: Torsten Hilbrich <torsten.hilbrich@secunet.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15 Mar 2011, at 10:17, Torsten Hilbrich wrote:
> On 10.03.2011 11:39, Torsten Hilbrich wrote:
>> I ran into the same problem and successfully applied your fix.
>> 
>> I was able to reproduce this panic and bisected it to the following commit:
>> 
>> commit aaead25b954879e1a708ff2f3602f494c18d20b5
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Mon Oct 4 14:25:33 2010 +0200
>> 
>>    writeback: always use sb->s_bdi for writeback purposes
>> 
>> The steps to reproduce it on my test system (T60p with Intel Core Duo) were.
> 
> Added Christoph to CC. I also open a bug report at https://bugzilla.kernel.org/show_bug.cgi?id=31112

This is already being handled.  It is the same as other bug reports, i.e. the fact that sb->s_bdi is made NULL on device removal and if it happens at the wrong time you then get a NULL pointer dereference.

Jens Axboe just only yesterday posted an initial patch for this.  Can you please test it and report back if it does indeed cure the problem?

The patch can be found here for example:

	https://lkml.org/lkml/2011/3/14/25

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

