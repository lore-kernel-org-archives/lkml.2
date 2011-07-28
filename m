Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1G1Lag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:30:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38294 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1G1Lae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <1311410747-29947-13-git-send-email-nab@linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	<1311410747-29947-13-git-send-email-nab@linux-iscsi.org>
Date: Thu, 28 Jul 2011 13:30:33 +0200
Message-ID: <CAJAFBLCJVLA7RwmVBUPobzqV+j5T5GoV=uRoRqUDuQkJn41Qpw@mail.gmail.com>
Subject: Re: [PATCH 12/13] iscsi-target: Add misc utility logic
From: Fubo Chen <fubo.chen@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 10:45 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> +static int iscsit_do_rx_data(
> +       struct iscsi_conn *conn,
> +       struct iscsi_data_count *count)
> +{
> +       int data = count->data_length, rx_loop = 0, total_rx = 0, iov_len;
> +       u32 rx_marker_val[count->ss_marker_count], rx_marker_iov = 0;
> +       struct kvec iov[count->ss_iov_count], *iov_p;

How big can count->ss_iov_count be ? Can this make a stack overflow ?

Fubo.
