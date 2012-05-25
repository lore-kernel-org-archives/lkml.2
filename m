Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab2EYAdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:33:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37984 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2EYAdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
References: <20120524021429.GB12557@kroah.com>
	<Pine.LNX.4.44L0.1205241029260.1349-100000@iolanthe.rowland.org>
Date: Fri, 25 May 2012 08:33:35 +0800
Message-ID: <CACVXFVPu_nbVCVR_HTt9H764+4JKC3=GPyhsf8Lpsch4Fa=xqQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> The code there is racy already.  It does:
>
>                } else if (dev->driver && dev->driver->shutdown) {
>
> without any locking protection.  If the driver is unbound while this
> statement runs then dev->driver could be non-NULL for the first test
> and NULL for the second.

Yes,  I missed this one, :-)

>
>> > to fix the race by prevent driver core from probing or releasing once
>> > shutdown is started.
>> >
>> > How about the below patch?
>>
>> How about waiting for the original poster to respond as to exactly how
>> they are hitting this race before doing anything?
>
> In addition, the patch is too complicated.  For this type of
> synchronization you should use SRCU.  See
> Documentation/RCU/whatisRCU.txt and related files.

Yes, the synchronization should be a many reader vs. one
writer problem, RCU should be suitable.

Looks we think alike, :-)

I have studied RCU yesterday, but was afraid that may introduce
much more code, so not applied it in the patch. Will study it further
to figure out a new version.


Thanks,
--
Ming Lei
