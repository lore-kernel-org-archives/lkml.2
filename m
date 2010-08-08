Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0HHXnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 19:43:42 -0400
Received: from home.kolivas.org ([59.167.196.135]:41761 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0HHXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 19:43:40 -0400
X-Greylist: delayed 1458 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Aug 2010 19:43:40 EDT
From: Con Kolivas <con@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 2.6.35-ck1
Date: Mon, 9 Aug 2010 09:19:20 +1000
User-Agent: KMail/1.9.9
References: <201008071039.31188.kernel@kolivas.org>
In-Reply-To: <201008071039.31188.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008090919.20504.con@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010 10:39:31 am Con Kolivas wrote:
> These are patches designed to improve system responsiveness and
> interactivity with specific emphasis on the desktop, but suitable to any
> workload.
>
>
> Apply to 2.6.35:
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.35/2.6.35-
>ck1/patch-2.6.35-ck1.bz2

As discussed on the BFS release announce, here are some interbench results,
performed on a lower spec machine. Hyperthreading was enabled, so this was an
SMP config with 2 CPUs. Use a fixed width font to make it readable.

See you all next major 3 point kernel release.


Comparison of 2.6.35 v 2.6.35-ck1 on a pentium 4HT with 1GB ram.

Note the significantly higher number of deadlines met on ck1, and when
deadlines are not met, the worst case latencies are mostly better. These
are the two most important parameters to compare. Asterisk placed where
values are significantly better. >= 5% or 5ms is considered significant.

Using 2043662 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.35-ck1 at datestamp 201008082239

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.0        0.0		 100	        100
Video	   0.0 +/- 0.0        0.0		 100	        100
X	   0.0 +/- 0.0        0.0		 100	        100
Burn	   0.0 +/- 0.0        0.0		 100	        100
Write	   0.0 +/- 0.0        0.4 *		 100	        100
Read	   0.0 +/- 0.0        0.1		 100	        100
Compile	   0.0 +/- 0.0        0.3 *		 100	        100
Memload	   0.0 +/- 0.0        0.1 *		 100	        100 *

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.0        0.0 *		 100	        100 *
X	   0.0 +/- 0.0        0.0 *		 100	        100 *
Burn	   0.0 +/- 0.0 *      0.0 *		 100	        100 *
Write	   0.1 +/- 1.5       22.7 *		 100 *	       99.3 *
Read	   0.0 +/- 0.0        0.1 *		 100	        100 *
Compile	   2.1 +/- 6.0 *     23.7 *		 100 *	       87.5 *
Memload	   0.2 +/- 1.7       23.7		 100 *	         99 *

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.5 +/- 2.9 *     39.0 *		89.3 *	       86.4 *
Video	  17.3 +/- 31.1      80.0 *		32.3	       22.8
Burn	  30.3 +/- 47.1 *    104.0 *		23.1 *	       13.4 *
Write	   5.6 +/- 13.2      54.0 *		60.1	       51.5
Read	   1.6 +/- 5.5       55.0		77.7 *	       72.1 *
Compile	  43.1 +/- 62.9 *    150.0 *		  18	       8.63
Memload	   2.7 +/- 7.4 *     35.0 *		71.6 *	       63.7 *

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	  72.4 +/- 94.7     166.6		  58
Video	  76.1 +/- 76.5 *    82.0 *		56.8 *
X	  67.6 +/- 74.1 *   104.3 *		59.7 *
Burn	 103.3 +/- 103.9 *  107.5 *		49.2 *
Write	  38.4 +/- 41.3      81.8		72.3
Read	  13.1 +/- 14.1 *    45.2		88.4
Compile	 125.9 +/- 127.3 *  215.3 *		44.3
Memload	  30.3 +/- 34.7 *   145.0 *		76.7



Using 2043662 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.35 at datestamp 201008082220

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.0        0.0		 100	        100
Video	   0.0 +/- 0.0        0.0		 100	        100
X	   0.0 +/- 0.0        0.0		 100	        100
Burn	   0.0 +/- 0.0        0.0		 100	        100
Write	   0.1 +/- 0.3        5.0		 100	        100
Read	   0.0 +/- 0.0        0.1		 100	        100
Compile	   0.1 +/- 0.8       11.0		 100	        100
Memload	   0.1 +/- 2.0       50.0		99.8	       99.8

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.2 +/- 1.9       16.7		 100	       98.6
X	   1.8 +/- 5.4       16.7		 100	       89.5
Burn	  11.5 +/- 13.9      16.7		 100	       31.1
Write	   1.4 +/- 4.9       40.3		99.9	       92.1
Read	   0.2 +/- 1.8       16.7		 100	       98.9
Compile	   9.2 +/- 14.0      46.3		89.9	       49.2
Memload	   1.2 +/- 4.4       22.7		 100	       93.3

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   5.9 +/- 15.3     104.0		57.8	       48.8
Video	  13.4 +/- 26.1     100.0		36.4	       27.7 *
Burn	  40.4 +/- 60.6     150.0		18.8	       9.84
Write	   7.0 +/- 16.0      84.0		58.5	       47.4
Read	   2.5 +/- 6.5       30.0 *		74.8	       66.1
Compile	  55.0 +/- 76.4     288.0		18.1	       7.28
Memload	   8.7 +/- 26.7     290.0		51.6	       43.6

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	  32.7 +/- 52.2 *   167.0		75.4 *
Video	 114.6 +/- 116.5    161.0		46.6
X	  88.3 +/- 96.6     166.9		53.1
Burn	 139.1 +/- 141.5    167.0		41.8
Write	  33.1 +/- 36.2 *    83.2		75.1
Read	  20.1 +/- 20.6      51.3		83.3
Compile	 138.8 +/- 142.9    312.8		41.9
Memload	  36.7 +/- 46.5     197.4		73.1

--
-ck
