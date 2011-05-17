Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1EQNvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:51:54 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:40889 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754710Ab1EQNvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:51:52 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 87M7rTcVM1nnTNh9MMpByUCmzeiONtMskKFThJbGFGM6YAn
 hbBDDPuvwpdvQrLyIszPESEPhzDZp1Qid6UY1okkqx7h5j0E6SHN3b9jPHhg
 p3G4pHexABSUcBo9FXsVvZoK.2.6u7CEZ0W4PNxEidX1F0IpGJZ1UpebVPbI
 Vwh6cy7pc4cb66rEYbn9dxIjAZVrX7o5bOB4CSkbFzwgGUuJD8Y.MacNlb4G
 04YdAsA4hycHrj0zf.tiD_o7p6jhsJxIRvbnbktFVqLto_2avyhmqBD7cTiw
 .PjoYi.jjwCjDbl5mRQ_6Yb7DXZku1ieE3YnvvFFpaEU10x3s
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 May 2011 08:51:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: slub: Do not take expensive steps for SLUBs
 speculative high-order allocations
In-Reply-To: <20110517084227.GI5279@suse.de>
Message-ID: <alpine.DEB.2.00.1105170847550.11187@router.home>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161411440.4353@chino.kir.corp.google.com> <20110517084227.GI5279@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Mel Gorman wrote:

> entirely. Christoph wants to maintain historic behaviour of SLUB to
> maximise the number of high-order pages it uses and at the end of the
> day, which option performs better depends entirely on the workload
> and machine configuration.

That is not what I meant. I would like more higher order allocations to
succeed. That does not mean that slubs allocation methods and flags passed
have to stay the same. You can change the slub behavior if it helps.

I am just suspicious of compaction. If these mods are needed to reduce the
amount of higher order pages then compaction does not have the
beneficial effect that it should have. It does not actually
increase the available higher order pages. Fix that first.



