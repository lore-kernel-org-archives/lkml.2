Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2GJRMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:12:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64670 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2GJRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120710154410.GA29892@aftab.osrc.amd.com>
References: <3908561D78D1C84285E8C5FCA982C28F19348DFF@ORSMSX104.amr.corp.intel.com>
	<f830ac24f491389b0246af0fb31d0546f3583380.1341866155.git.tony.luck@intel.com>
	<20120710154410.GA29892@aftab.osrc.amd.com>
Date: Tue, 10 Jul 2012 10:12:17 -0700
X-Google-Sender-Auth: Lx_3UPWrCdvWPF6UYZA0tl6OHps
Message-ID: <CA+8MBbKU5AB5zpYQB6pHegA2V1=8q123fxyFERsHjWCLK5iCsw@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed process
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 8:44 AM, Borislav Petkov <bp@amd64.org> wrote:
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks for the Ack.

+       doit = !!PageDirty(ppage) || !!(flags & MF_MUST_KILL);

Thinking about this some more, the "!!" are redundant
and are an impediment to readability. We started with
!!PageDirty(ppage) when we were passing an argument
directly to kill_procs() and wanted to make sure we had a
nice boolean value. But the result of the "||" is boolean,
so we don't need to double negate.

I'm going to change it to:
       doit = PageDirty(ppage) || (flags & MF_MUST_KILL);

-Tony
