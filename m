Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab2LWHWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 02:22:18 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56271 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2LWHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 02:22:17 -0500
Message-ID: <50D6AFF2.1010708@gmail.com>
Date: Sun, 23 Dec 2012 02:17:06 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Drunkard Zhang <gongfan193@gmail.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mvsas regression since 3.5
References: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
In-Reply-To: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/12 10:33 AM, Drunkard Zhang wrote:
> I'm using Asus PIKE 6480 SAS card, whose chipset is "RAID bus
> controller: Marvell Technology Group Ltd. MV64460/64461/64462 System
> Controller, Revision B", with latest stable branch 3.7.1 only 1 of 8
> ports works, to get others works I got to pull & plug back. While with
> 3.5.7 it's all good, so it must be a regression.

Can you try to revert commit beecadea1b8d67f591b13f7099559f32f3fd601d?

Particularly, can you first change

  #define bit(n) ((u64)1 << n)

in drivers/scsi/mvsas/mv_sas.h back to

  #define bit(n) ((u32)1 << n)

and see if it works for you?  Thanks.

- xi
