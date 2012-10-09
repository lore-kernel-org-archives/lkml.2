Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2JINjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:39:15 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:44840 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2JINjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:39:13 -0400
X-ASG-Debug-ID: 1349789952-03d6a559e036cca0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Tue, 9 Oct 2012 09:39:10 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove repeated eb->pages check in,
 disk-io.c/csum_dirty_buffer
Message-ID: <20121009133910.GA9275@shiny>
X-ASG-Orig-Subj: Re: [PATCH] Btrfs: remove repeated eb->pages check in,
 disk-io.c/csum_dirty_buffer
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Wang Sheng-Hui <shhuiw@gmail.com>,
	Chris Mason <clmason@fusionio.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5072D477.3070303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5072D477.3070303@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1349789952
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.110853
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 07:26:15AM -0600, Wang Sheng-Hui wrote:
> In csum_dirty_buffer, we first get eb from page->private.
> Then we check if the page is the first page of eb. Later
> we check it again. Remove the repeated check here.

You had the right idea here, two checks and one has a warning, so you
kept the warning.  But when the metadata block size is bigger than a
page, the WARN_ON triggers for any page that isn't the first one in the
extent buffer.

I kept this commit but removed the WARN_ON(1)

-chris
