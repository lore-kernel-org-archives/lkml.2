Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3ACQ2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:28:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40919 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3ACQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:28:16 -0500
Message-ID: <50E5B173.7070807@linux.vnet.ibm.com>
Date: Thu, 03 Jan 2013 08:27:31 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 2/8] Don't allow volatile attribute on THP and KSM
References: <1357187286-18759-1-git-send-email-minchan@kernel.org> <1357187286-18759-3-git-send-email-minchan@kernel.org>
In-Reply-To: <1357187286-18759-3-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010316-2876-0000-0000-000003C6F754
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 08:28 PM, Minchan Kim wrote:
> VOLATILE imply the the pages in the range isn't working set any more
> so it's pointless that make them to THP/KSM.

One of the points of this implementation is that it be able to preserve
memory contents when there is no pressure.  If those contents happen to
contain a THP/KSM page, and there's no pressure, it seems like the right
thing to do is to leave that memory in place.

It might be a fair thing to do this in order to keep the implementation
more sane at the moment.  But, we should make sure there's some good
text on that in the changelog.

