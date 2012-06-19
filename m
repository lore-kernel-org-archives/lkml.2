Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2FSCKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:10:01 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:40360 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2FSCJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:09:59 -0400
Message-ID: <1340071797.1666.24.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2012 12:09:57 +1000
In-Reply-To: <201206182328.19811.rjw@sisk.pl>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
	 <201206182229.32055.rjw@sisk.pl>
	 <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
	 <201206182328.19811.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 23:28 +0200, Rafael J. Wysocki wrote:
> I think I'd prefer a full status line every 10%.  Or even maybe every
> 20%.

Here is one that does a line every 10%:
----------------
 kernel/power/swap.c |   51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 11e22c0..314fd75 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -448,9 +448,9 @@ static int save_image(struct swap_map_handle *handle,
 	struct timeval start;
 	struct timeval stop;
 
-	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
+	printk(KERN_INFO "PM: Saving image data pages (%u pages)...\n",
 		nr_to_write);
-	m = nr_to_write / 100;
+	m = nr_to_write / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -464,7 +464,8 @@ static int save_image(struct swap_map_handle *handle,
 		if (ret)
 			break;
 		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+			printk(KERN_INFO "PM: Saved %3d%%...\n",
+			       nr_pages / m * 10);
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
@@ -472,9 +473,7 @@ static int save_image(struct swap_map_handle *handle,
 	if (!ret)
 		ret = err2;
 	if (!ret)
-		printk(KERN_CONT "\b\b\b\bdone\n");
-	else
-		printk(KERN_CONT "\n");
+		printk(KERN_INFO "PM: Saving image done.\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 	return ret;
 }
@@ -668,9 +667,9 @@ static int save_image_lzo(struct swap_map_handle *handle,
 
 	printk(KERN_INFO
 		"PM: Using %u thread(s) for compression.\n"
-		"PM: Compressing and saving image data (%u pages) ...     ",
+		"PM: Compressing and saving image data (%u pages)...\n",
 		nr_threads, nr_to_write);
-	m = nr_to_write / 100;
+	m = nr_to_write / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -690,8 +689,8 @@ static int save_image_lzo(struct swap_map_handle *handle,
 				       data_of(*snapshot), PAGE_SIZE);
 
 				if (!(nr_pages % m))
-					printk(KERN_CONT "\b\b\b\b%3d%%",
-				               nr_pages / m);
+					printk(KERN_INFO "PM: Saved %3d%%...\n",
+				               nr_pages / m * 10);
 				nr_pages++;
 			}
 			if (!off)
@@ -761,11 +760,8 @@ out_finish:
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
-	if (!ret) {
-		printk(KERN_CONT "\b\b\b\bdone\n");
-	} else {
-		printk(KERN_CONT "\n");
-	}
+	if (!ret)
+		printk(KERN_INFO "PM: Saving image done.\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 out_clean:
 	if (crc) {
@@ -973,9 +969,9 @@ static int load_image(struct swap_map_handle *handle,
 	int err2;
 	unsigned nr_pages;
 
-	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
+	printk(KERN_INFO "PM: Loading image data pages (%u pages)...\n",
 		nr_to_read);
-	m = nr_to_read / 100;
+	m = nr_to_read / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -993,7 +989,8 @@ static int load_image(struct swap_map_handle *handle,
 		if (ret)
 			break;
 		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
+			printk(KERN_INFO "PM: Loaded %3d%%...\n",
+			       nr_pages / m * 10);
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
@@ -1001,12 +998,11 @@ static int load_image(struct swap_map_handle *handle,
 	if (!ret)
 		ret = err2;
 	if (!ret) {
-		printk("\b\b\b\bdone\n");
+		printk(KERN_INFO "PM: Loading image done.\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
-	} else
-		printk("\n");
+	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 	return ret;
 }
@@ -1185,9 +1181,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
 
 	printk(KERN_INFO
 		"PM: Using %u thread(s) for decompression.\n"
-		"PM: Loading and decompressing image data (%u pages) ...     ",
+		"PM: Loading and decompressing image data (%u pages)...\n",
 		nr_threads, nr_to_read);
-	m = nr_to_read / 100;
+	m = nr_to_read / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -1319,7 +1315,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
 				       data[thr].unc + off, PAGE_SIZE);
 
 				if (!(nr_pages % m))
-					printk("\b\b\b\b%3d%%", nr_pages / m);
+					printk(KERN_INFO
+					       "PM: Loaded %3d%%...\n",
+					       nr_pages / m * 10);
 				nr_pages++;
 
 				ret = snapshot_write_next(snapshot);
@@ -1344,7 +1342,7 @@ out_finish:
 	}
 	do_gettimeofday(&stop);
 	if (!ret) {
-		printk("\b\b\b\bdone\n");
+		printk(KERN_INFO "PM: Loading image done.\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
@@ -1357,8 +1355,7 @@ out_finish:
 				}
 			}
 		}
-	} else
-		printk("\n");
+	}
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 out_clean:
 	for (i = 0; i < ring_size; i++)
----------------

-- 
Bojan

