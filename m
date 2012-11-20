Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2KTQOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:14:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2KTQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:14:22 -0500
Date: Tue, 20 Nov 2012 16:14:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Eilon Greenstein <eilong@broadcom.com>
Cc: Joe Perches <joe@perches.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
Message-ID: <20121120161417.GA17797@dm>
References: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120115239.GA7955@dm>
 <1353421624.6559.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120144329.GE7955@dm>
 <1353424027.6559.15.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120154443.GK7955@dm>
 <1353427570.6559.21.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353427570.6559.21.camel@lb-tlvb-eilong.il.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 06:06:10PM +0200, Eilon Greenstein wrote:
> I'm only testing the nextline if the current line is newly added. If I
> got it right, when a line is newly added, the next line can be:
> a. another new line
> b. existing line (provided for context)
> c. Does not exist since this is the end of the file (I missed this one
> originally)
> 
> It cannot just jump to the next hunk and it cannot be a deleted line,
> right?

Mostly that would be true.  If the hunk is the last hunk and adds lines
at the bottom of a file _and_ the context around it has blank lines then
something.  I think that would trip up this algorithm, reporting beyond
the end of the hunk perhaps.

-apw
