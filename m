Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1KCOls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:41:48 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:41678 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1KCOlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <1320331063.2813.78.camel@hp6530s>
References: <Pine.LNX.4.44L0.1111031019250.2136-100000@iolanthe.rowland.org>
	<1320331063.2813.78.camel@hp6530s>
Date: Thu, 3 Nov 2011 07:41:43 -0700
X-Google-Sender-Auth: B-glCDseWeJmkF-NfXKxKV8Laes
Message-ID: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 7:37 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> Yes, it is a problem.  But it looks like the underlying issue is that
>> you're using the SCSI error handler to do something it was not intended
>> for.  Can't you suspend and resume the ATA port without using the error
>> handler?
>
> The system suspend and resume of the ATA port uses the error handler.
> I think the runtime suspend and resume should use the error handler too.
>
> Tejun,
>
> Could you comment more on this?

I don't know. I haven't really thought about it but as it's currently
designed, I don't think it'll be possible to avoid going through EH to
put ATA ports into suspend mode.

Thanks.

-- 
tejun
