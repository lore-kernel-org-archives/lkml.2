Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2BPCWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:22:49 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:33646 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756791Ab2BPCWs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:22:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1202151801020.19691@eggly.anvils>
References: <20120215183317.GA26977@redhat.com> <alpine.LSU.2.00.1202151801020.19691@eggly.anvils>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 15 Feb 2012 18:22:27 -0800
Message-ID: <CAL1RGDVQDr-h5Makto-FXHeHUkK4sJooszciiNvVR66WonQ=6w@mail.gmail.com>
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 6:14 PM, Hugh Dickins <hughd@google.com> wrote:
> My suspicion was that it would be related to Transparent HugePages:
> they do complicate the pagetable story.  And I think I have found a
> potential culprit.  I don't know if nr_ptes is the only loser from
> these two split_huge_pages calls, but assuming it is...

Do you have an idea when this bug might have been introduced?
Presumably it's been there since THP came in?

The reason I ask is that I have one of these exit_mm BUG_ONs
in my pile of one-off unreproducible crashes, but in my case it
happened with 2.6.39 (with THP enabled).  So I'm wondering if
I can cross it off my list and blame this bug, or if it remains one
of those inexplicable mysteries...

Thanks,
  Roland
