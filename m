Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269Ab2EWPf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:35:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43744 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965195Ab2EWPf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
References: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
Date: Wed, 23 May 2012 23:35:56 +0800
X-Google-Sender-Auth: gKeHPSxyB65PV1iE4FUZQvgL46Y
Message-ID: <CAF1ivSbVHUgauQHBRm9Cyo_Fm3gQ0W+R_fQ6gQHAY6B=Q4WsRQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/4] block: add a flag to identify PM request
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:02 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> Add a flag REQ_PM to identify the request is PM related.
>> As an example, modify scsi code to use this flag.
>
> Don't forget to check up on the SCSI error handler.  If I'm not
> mistaken, the libata drivers use it during suspend and resume.  Also,

You are right.

ata_port_suspend_common
  ata_port_request_pm
    ata_port_schedule_eh
      scsi_schedule_eh
        scsi_error_handler ---> libata error handler

I just have a quick look and it seems libata error handler does not
send SCSI request.
Will check more.

> the error handler will run if one of the REQ_PM commands encounters an
> error.
>
> Therefore it seems likely that every request submitted by the error
> handler needs to have REQ_PM set.
>
> Alan Stern
