Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0FCRk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:40:58 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:33153 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0FCRk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:40:57 -0400
X-Greylist: delayed 830 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 13:40:57 EDT
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 13:40:56 -0400
X-Google-Sender-Auth: FDc5PCJV2fQjsH8pSgA7XDsvvK0
Message-ID: <AANLkTikOfpj7YhRU4W3PxK1ONC8552YhBsPM-2UleHzo@mail.gmail.com>
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
From: Gregory Moyer <raven2k@syphr.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
>
> Alright, I don't have access to mcp51 but tested with mcp55 and could
> reproduce similar problem. It seems nIEN on mcp55 is stuck once set
> and iHOS104 doesn't set I on D2H FIS if nIEN is set on command H2D
> FIS, which the SATA standard specifically mandates not to do. So, the
> combination of buggy mcp55 ctl handling + buggy iHOS104 nIEN handling
> leads to nobody raising interrupt.
>
> The problem is that the problem I'm seeing is not completely identical
> to the one you're seeing. The difference could be coming from
> different firmware version on the drives or different controllers.
>
> Anyways, can you please give a shot at the attached patch?
>
> Thanks.
>
> --
> tejun


I tried your latest patch against 2.6.32 with my iHOS104 and MCP55 and
it works perfectly. I can now use the drive normally and I do not see
any failure/reset messages in the log. Thanks!
- Greg
