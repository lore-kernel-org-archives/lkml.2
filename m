Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1KPPwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:52:10 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53346 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab1KPPwI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:52:08 -0500
X-AuditID: 1209190c-b7f806d0000008d6-1d-4ec3dc273f22
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 16 Nov 2011 10:51:59 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42IRYrdT0VW/c9jPYM0jI4vm1Q+YLK7fvcVs
	MXPeHTaLy7vmsDmweOycdZfd4/MmuQCmKC6blNSczLLUIn27BK6MD92rmQsOsFYsmK/dwLiU
	pYuRk0NCwETiWOszdghbTOLCvfVsXYxcHEIC+xglrt/+ygLhbGCUuND0nRXCWcEk8fTzCkaQ
	FmEBF4lH316D2bwCxhJrbr0DG8ssoCex4/ovVhCbTUBJ4s6n/WBxTqD6w3cng61jEVCV6F50
	FWwds0Afo8SJWf1QzdoSyxa+ZoYYaiWxrvko2CAhAWeJG+3HgRo4OEQE1CQmPEuFOFteouXr
	HbYJjIKzkJwxC8kZs5BMXcDIvIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXUC83s0QvNaV0EyMo
	pDkleXYwvjmodIhRgINRiYf31ZxDfkKsiWXFlbmHGCU5mJREeU0vH/YT4kvKT6nMSCzOiC8q
	zUktPsQowcGsJMLrsgsox5uSWFmVWpQPk5LmYFES5z24w8FPSCA9sSQ1OzW1ILUIJivDwaEk
	wWt6G6hRsCg1PbUiLTOnBCHNxMEJMpwHaLgWSA1vcUFibnFmOkT+FKOilDivDUhCACSRUZoH
	1wtLOa8YxYFeEeZ9eQuoigeYruC6XwENZgIavPbgAZDBJYkIKakGRt6IGDYTiZPxMecf6n07
	2XOYWU0mVdDv+ToRtn/cD4tNu171vd/9Myvo0O23S14d0jHXcthcpnApcOOSZJPHLRIpc6Y4
	LA393lUzKfRXW4KMuiqHzsQ9c4VzPf7KSF6bVFaeyvOtJT2oVsU611P109dVLxMeHDLP9nn2
	9/KTW3Z5Rno+Ms73lFiKMxINtZiLihMBmz3u9hQDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 16, 2011, at 10:04 AM, Namjae Jeon wrote:

> If slab caches set to SLAB_MEM_SPREAD flags, The allocation is spread evenly over all the memory nodes instead of favoring allocation on the node local to current cpu.

And why do you think this is a good thing?   For mballoc in particular, the data structures are used immediately and then freed immediately --- on the local node, so using a non-local memory just makes things worse in a NUMA system.

For the pageio, they are used immediately, and may end up getting freed on the same CPU if the I/O interrupt (and hence competion callbacks) happen on the same CPU that they are submitted on….

Regards,

-- Ted


