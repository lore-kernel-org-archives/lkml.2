Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1IAR6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:58:43 -0400
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:32996 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755592Ab1IAR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110901160724.GN9189@beardog.cce.hp.com> <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 1 Sep 2011 10:58:21 -0700
Message-ID: <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: scameron@beardog.cce.hp.com, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK I found the bad commit,I got lucky... I lost some files but my
> machine was able to complete the bisection. CC involved people

> # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric

Hi Eric,

I guess it would be useful to see "lspci -vv" output with a "good" kernel
and with that bad patch applied.  Most likely we should see some difference
somewhere in the MaxPayload fields in the PCI Express capability of
some device.

Either the RAID controller or something else lies, and puts a value
in the DevCap that it can't actually support, or else the patch is
buggy and puts something out of range in a DevCtl somewhere.

 - R.
