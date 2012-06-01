Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2FABpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:45:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29863 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab2FABo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:44:59 -0400
Message-ID: <4FC81E79.1080003@oracle.com>
Date: Fri, 01 Jun 2012 09:44:25 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH 2/2] ocfs2: clear unaligned io flag when dio fails
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com> <1338437550-24499-2-git-send-email-junxiao.bi@oracle.com> <x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 10:09 PM, Jeff Moyer wrote:
> Junxiao Bi <junxiao.bi@oracle.com> writes:
>
>> The unaligned io flag is set in the kiocb when an unaligned
>> dio is issued, it should be cleared even when the dio fails,
>> or it may affect the following io which are using the same
>> kiocb.
> What code is re-using kiocbs, much less re-using them without
> re-initializing them?
See my comment in another thread. aio_write seems called two times with
the same kiocb.
>
> -Jeff

