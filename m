Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1KVNRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:17:08 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:45140 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab1KVNRG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:17:06 -0500
X-AuditID: 12074425-b7f116d0000008fe-44-4ecba0d12154
Subject: Re: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111122104921.GE8098@dastard>
Date: Tue, 22 Nov 2011 08:17:07 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <ED3D1B07-DEC4-43C8-80A9-739C4973ABF9@mit.edu>
References: <20111121142056.GF2386@dastard> <20111122035629.GE20982@localhost> <20111122102931.GD8098@dastard> <20111122104921.GE8098@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42IRYrdT0b244LSfwaseIYstx+4xWrx/vp7Z
	Ys/ekywWl3fNYXNg8Ti1SMJj8Z6XTB6fN8kFMEdx2aSk5mSWpRbp2yVwZWzo6GUruMlWcW3e
	bbYGxrWsXYycHBICJhJtt+eyQ9hiEhfurWfrYuTiEBLYxyix4vM0KGcDo8Th9pdMEM5pJokH
	ly8DtXBwCAt4SiybpAjSzStgLLHm1jsWEJtZQE9ix/VfYBvYBJQk7nzaDxbnFNCRWLulE2wb
	i4CqxPO9HxhBZjIL3GSUmPPiBBNEs7bEsoWvmUHm8wpYSXSt8YXY28co0fRlKthQEQE1iUmT
	djBDnC0v0fL1DtsERsFZSO6YheSOWUjGLmBkXsUom5JbpZubmJlTnJqsW5ycmJeXWqRroZeb
	WaKXmlK6iREc3C6qOxgnHFI6xCjAwajEw/tr8ik/IdbEsuLK3EOMkhxMSqK8C+ed9hPiS8pP
	qcxILM6ILyrNSS0+xCjBwawkwnulHSjHm5JYWZValA+TkuZgURLnfb3DwU9IID2xJDU7NbUg
	tQgmK8PBoSTBe3c+UKNgUWp6akVaZk4JQpqJgxNkOA/Q8IsgNbzFBYm5xZnpEPlTjIpS4rxP
	QBICIImM0jy4XljyecUoDvSKMC8XMBUJ8QATF1z3K6DBTECDp609ATK4JBEhJdXAKPqwpmy9
	iF/xq33rPA/W/LqRLfuzMtRC+OW9W/9bfl8WvVDsGHS/S2iC1Nm0zZ0nH31rdlGYfsFzw3n7
	bCW7uI6fGvI2u+XetpZkbTCvj5/Zc7ZVlElqS4v2vie3ooPvBzi5ei4o8TO19Oi/rlkv2aaw
	0u6Kzq1He6R3b1JP410kZliR7rdNiaU4I9FQi7moOBEAfDWymRkDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 22, 2011, at 5:49 AM, Dave Chinner wrote:

> But, I just noticed that the discard that mkfs.ext4 will result in
> all the extents being discarded in the underlying image file (due to
> the fact the loopback device now supports hole punching), so the
> previous state of the image file is getting trashed by the mkfs.ext4
> execution, too. I think I already had a ext4 filesystem in some state
> before I started running this manual prealloc test....

Which version of mkfs.ext4 are you using?   We've disabled the discard by default (unless configured in via a command-line option or a /etc/mke2fs.conf setting since no distribution apparently wants to be responsible for running supplying a command that causes a crap SSD to turning into a brick; personally, I'd blame the manufacturer of the crap SSD, but….)

-- Ted

