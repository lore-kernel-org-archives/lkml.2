Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1ACRp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:45:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49403 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab1ACRpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:45:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TlvJ7aatJC9C99nJ8bq9SKw9aMn2O0WhD09/SHsV+l6JRLDfSMuq8ppX6BXWEYSHne
         zVOc9PiJ2yrV3JV+xMiVC3w6/kpLs7OPuDAHAbCWadi80BfJiVkZW+2fzjy71WQwAXgR
         3ALOCfmDBjDBL4e1lD5ezCqHeqFy/y44uiN84=
MIME-Version: 1.0
In-Reply-To: <1294062595-30097-18-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-18-git-send-email-tj@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 3 Jan 2011 18:45:33 +0100
X-Google-Sender-Auth: A6kNAEoTTctkGivO25v8LibWNOg
Message-ID: <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd workqueue
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 2:49 PM, Tejun Heo <tj@kernel.org> wrote:
> The target driver is not in the memory reclaim path and doesn't need a
> dedicated workqueue.  Drop vtgtd and use system_wq instead.  The used
> work item is sync flushed on removal.

[ ... ]

Hi Tejun,

No matter which storage target will go upstream, I'm afraid that this
patch will conflict with it. See e.g.
http://dchs.spinics.net/lists/linux-scsi/msg49105.html.

Bart.
