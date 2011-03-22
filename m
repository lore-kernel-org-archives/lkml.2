Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1CVM55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab1CVM5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:57:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sd: Free the page in case of unknown provisioning_mode in scsi_setup_discard_cmnd.
References: <1300766648-18095-1-git-send-email-tm@tao.ma>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Mar 2011 08:57:51 -0400
In-Reply-To: <1300766648-18095-1-git-send-email-tm@tao.ma> (Tao Ma's message
	of "Tue, 22 Mar 2011 12:04:08 +0800")
Message-ID: <x494o6vtir4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tm@tao.ma> writes:

> From: Tao Ma <boyu.mt@taobao.com>
>
> This patch is inspired by a build waring.
> drivers/scsi/sd.c:544: warning: ‘ret’ may be used uninitialized in this function
>
> So we need to set a default value to ret here.
> But a deep look at scsi_setup_discard_cmnd makes me think
> of which value should be set. Now we have BLKPREP_KILL and
> BLKPREP_DEFER to indicate an error. As in case of an
> unknown sdkp->provisioning_mode, we goto out directly. So
> I guess we should return BLKPREP_KILL here and free the page.

Yeah, there's no point in deferring it.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
