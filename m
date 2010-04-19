Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0DSPvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:51:36 -0400
Received: from exhub016-4.exch016.msoutlookonline.net ([207.5.72.225]:18530
	"EHLO EXHUB016-4.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab0DSPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:51:35 -0400
Message-ID: <4BCC7C05.8000803@cfl.rr.com>
Date: Mon, 19 Apr 2010 11:51:33 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: readahead on directories
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been trying to improve boot times with ureadahead and have
identified a period of time of almost zero IO throughput caused by calls
to open() blocking during name lookup while fetching directory blocks.
At first I thought this could simply be fixed by calling readahead() on
the directories first before open()ing all of the normal files for
readahead.

Unfortunately it seems that readahead() fails when called on a
directory.  I was wondering if I could get some help understanding why
this is, and how it could be fixed.
