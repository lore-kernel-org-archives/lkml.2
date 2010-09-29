Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0I2HeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:34:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:49065 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0I2HeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:34:16 -0400
Date: Wed, 29 Sep 2010 09:34:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100929093403.7db92388@endymion.delvare>
In-Reply-To: <20100928211246.GA20941@lixom.net>
References: <20100928211246.GA20941@lixom.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olaf,

On Tue, 28 Sep 2010 16:12:46 -0500, Olof Johansson wrote:
> I've found this quite useful since it allows dmidecode to run without
> root privileges using --from-dump to read this file instead

This is a bad idea. We do NOT want every user to have access to all the
DMI information. There is sensitive information in there (serial
numbers and UUIDs, and possibly even more sensitive data in
OEM-specific records.) If you look in /sys/class/dmi/id/, you'll see
that files board_serial, chassis_serial, product_serial and
product_uuid are only readable by root exactly for this reason.

So this is a NACK from me, sorry.

-- 
Jean Delvare
