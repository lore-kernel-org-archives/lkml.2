Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2FLNXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2FLNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:42 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 2/5] edac: remove arch-specific parameter for the error handler
Date: Tue, 12 Jun 2012 10:23:28 -0300
Message-Id: <03f7eae80f4b913929be84e0c883ee98196fd6ff.1339507095.git.mchehab@redhat.com>
In-Reply-To: <cover.1339507094.git.mchehab@redhat.com>
References: <cover.1339507094.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the arch-dependent parameter, as it were not used,
as the MCE tracepoint weren't implemented. It probably doesn't
make sense to have an MCE-specific tracepoint, as this will
cost more bytes at the tracepoint, and tracepoint is not free.

The changes at the EDAC drivers were done by this small perl script:

	$file .=$_ while (<>);
	$file =~ s/(edac_mc_handle_error)\s*\(([^\;]+)\,([^\,\)]+)\s*\)/$1($2)/g;
	print $file;

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |   30 +++++++++++-------------------
 drivers/edac/amd76x_edac.c     |    4 ++--
 drivers/edac/cell_edac.c       |    4 ++--
 drivers/edac/cpc925_edac.c     |    4 ++--
 drivers/edac/e752x_edac.c      |    8 ++++----
 drivers/edac/e7xxx_edac.c      |    8 ++++----
 drivers/edac/edac_core.h       |    3 +--
 drivers/edac/edac_mc.c         |    6 +-----
 drivers/edac/edac_mc_sysfs.c   |    2 +-
 drivers/edac/i3000_edac.c      |    6 +++---
 drivers/edac/i3200_edac.c      |    6 +++---
 drivers/edac/i5000_edac.c      |    8 ++++----
 drivers/edac/i5100_edac.c      |    4 ++--
 drivers/edac/i5400_edac.c      |    4 ++--
 drivers/edac/i7300_edac.c      |    4 ++--
 drivers/edac/i7core_edac.c     |    4 ++--
 drivers/edac/i82443bxgx_edac.c |    4 ++--
 drivers/edac/i82860_edac.c     |    6 +++---
 drivers/edac/i82875p_edac.c    |    6 +++---
 drivers/edac/i82975x_edac.c    |    6 +++---
 drivers/edac/mpc85xx_edac.c    |    4 ++--
 drivers/edac/mv64x60_edac.c    |    4 ++--
 drivers/edac/pasemi_edac.c     |    4 ++--
 drivers/edac/ppc4xx_edac.c     |    4 ++--
 drivers/edac/r82600_edac.c     |    4 ++--
 drivers/edac/sb_edac.c         |    4 ++--
 drivers/edac/tile_edac.c       |    2 +-
 drivers/edac/x38_edac.c        |    6 +++---
 28 files changed, 73 insertions(+), 86 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 811d3e8..6231cbe 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1050,8 +1050,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a node",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1062,8 +1061,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a csrow",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1083,8 +1081,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 					     page, offset, syndrome,
 					     csrow, -1, -1,
 					     "unknown syndrome - possible error reporting race",
-					     "",
-					     NULL);
+					     "");
 			return;
 		}
 	} else {
@@ -1102,7 +1099,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
 			     page, offset, syndrome,
 			     csrow, channel, -1,
-			     "", "", NULL);
+			     "", "");
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1615,8 +1612,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a csrow",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1631,7 +1627,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     page, offset, syndrome,
 			     csrow, chan, -1,
-			     "", "", NULL);
+			     "", "");
 }
 
 /*
@@ -1917,8 +1913,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 				     0, 0, 0,
 				     -1, -1, -1,
 				     "HW has no ERROR_ADDRESS available",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1946,8 +1941,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     0, 0, 0,
 				     -1, -1, -1,
 				     "HW has no ERROR_ADDRESS available",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1966,8 +1960,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     page, offset, 0,
 				     -1, -1, -1,
 				     "ERROR ADDRESS NOT mapped to a MC",
-				     "",
-				     NULL);
+				     "");
 		return;
 	}
 
@@ -1981,13 +1974,12 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     page, offset, 0,
 				     -1, -1, -1,
 				     "ERROR ADDRESS NOT mapped to CS",
-				     "",
-				     NULL);
+				     "");
 	} else {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     csrow, -1, -1,
-				     "", "", NULL);
+				     "", "");
 	}
 }
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index a015fba..c7c208e 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -148,7 +148,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
-					     mci->ctl_name, "", NULL);
+					     mci->ctl_name, "");
 		}
 	}
 
@@ -163,7 +163,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
-					     mci->ctl_name, "", NULL);
+					     mci->ctl_name, "");
 		}
 	}
 
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 478d8ee..165d255 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -50,7 +50,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	/* TODO: Decoding of the error address */
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     csrow->first_page + pfn, offset, syndrome,
-			     0, chan, -1, "", "", NULL);
+			     0, chan, -1, "", "");
 }
 
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
@@ -72,7 +72,7 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	/* TODO: Decoding of the error address */
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 			     csrow->first_page + pfn, offset, 0,
-			     0, chan, -1, "", "", NULL);
+			     0, chan, -1, "", "");
 }
 
 static void cell_edac_check(struct mem_ctl_info *mci)
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index a7ea398..32e9c88 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -557,7 +557,7 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, syndrome,
 				     csrow, channel, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 	}
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
@@ -565,7 +565,7 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, 0,
 				     csrow, -1, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 675ba3c..b5a8bf1 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -374,7 +374,7 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
 			     row, channel, -1,
-			     "e752x CE", "", NULL);
+			     "e752x CE", "");
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -412,7 +412,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
 					 row, -1, -1,
-					"e752x UE from Read", "", NULL);
+					"e752x UE from Read", "");
 
 	}
 	if (error_one & 0x0404) {
@@ -431,7 +431,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
 					row, -1, -1,
-					"e752x UE from Scruber", "", NULL);
+					"e752x UE from Scruber", "");
 	}
 }
 
@@ -456,7 +456,7 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 	edac_dbg(3, "\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 			     -1, -1, -1,
-			     "e752x UE log memory write", "", NULL);
+			     "e752x UE log memory write", "");
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 3ce661e..c26b69e 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -220,14 +220,14 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, page, 0, syndrome,
-			     row, channel, -1, "e7xxx CE", "", NULL);
+			     row, channel, -1, "e7xxx CE", "");
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	edac_dbg(3, "\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
-			     "e7xxx CE log register overflow", "", NULL);
+			     "e7xxx CE log register overflow", "");
 }
 
 static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
@@ -243,7 +243,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, block_page);
 
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, block_page, 0, 0,
-			     row, -1, -1, "e7xxx UE", "", NULL);
+			     row, -1, -1, "e7xxx UE", "");
 }
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
@@ -251,7 +251,7 @@ static void process_ue_no_info(struct mem_ctl_info *mci)
 	edac_dbg(3, "\n");
 
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
-			     "e7xxx UE log register overflow", "", NULL);
+			     "e7xxx UE log register overflow", "");
 }
 
 static void e7xxx_get_error_info(struct mem_ctl_info *mci,
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index ee25f54..500ba66 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -462,8 +462,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int mid_layer,
 			  const int low_layer,
 			  const char *msg,
-			  const char *other_detail,
-			  const void *arch_log);
+			  const char *other_detail);
 
 /*
  * edac_device APIs
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 91ca410..fb41e38c 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1044,9 +1044,6 @@ static void edac_ue_error(struct mem_ctl_info *mci,
  * @other_detail:	Technical details about the event that
  *			may help hardware manufacturers and
  *			EDAC developers to analyse the event
- * @arch_log:		Architecture-specific struct that can
- *			be used to add extended information to the
- *			tracepoint, like dumping MCE registers.
  */
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
@@ -1057,8 +1054,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int mid_layer,
 			  const int low_layer,
 			  const char *msg,
-			  const char *other_detail,
-			  const void *arch_log)
+			  const char *other_detail)
 {
 	/* FIXME: too much for stack: move it to some pre-alocated area */
 	char detail[80], location[80];
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 7079a42..107e7a7 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -827,7 +827,7 @@ static ssize_t edac_fake_inject_write(struct file *file,
 			     mci->fake_inject_layer[0],
 			     mci->fake_inject_layer[1],
 			     mci->fake_inject_layer[2],
-			     "FAKE ERROR", "for EDAC testing only", NULL);
+			     "FAKE ERROR", "for EDAC testing only");
 
 	return count;
 }
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 399aec3..dd07bea 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -247,7 +247,7 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 				     -1, -1, -1,
-				     "UE overwrote CE", "", NULL);
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -261,12 +261,12 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     pfn, offset, 0,
 				     row, -1, -1,
-				     "i3000 UE", "", NULL);
+				     "i3000 UE", "");
 	else
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, offset, info->derrsyn,
 				     row, multi_chan ? channel : 0, -1,
-				     "i3000 CE", "", NULL);
+				     "i3000 CE", "");
 
 	return 1;
 }
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index dfd843a..07ae442 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -219,7 +219,7 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
-				     -1, -1, -1, "UE overwrote CE", "", NULL);
+				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -230,13 +230,13 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 					     0, 0, 0,
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "i3000 UE", "", NULL);
+					     "i3000 UE", "");
 		} else if (log & I3200_ECCERRLOG_CE) {
 			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "i3000 UE", "", NULL);
+					     "i3000 UE", "");
 		}
 	}
 }
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 96431a5..0406f0d 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -522,7 +522,7 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
 			     channel >> 1, channel & 1, rank,
 			     rdwr ? "Write error" : "Read error",
-			     msg, NULL);
+			     msg);
 }
 
 /*
@@ -621,7 +621,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 				channel >> 1, -1, rank,
 				rdwr ? "Write error" : "Read error",
-				msg, NULL);
+				msg);
 	}
 
 	/* Check correctable errors */
@@ -675,7 +675,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
 				channel >> 1, channel % 2, rank,
 				rdwr ? "Write error" : "Read error",
-				msg, NULL);
+				msg);
 	}
 
 	if (!misc_messages)
@@ -720,7 +720,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		/* Call the helper to output message */
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
 				branch >> 1, -1, -1,
-				"Misc error", msg, NULL);
+				"Misc error", msg);
 	}
 }
 
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index a9b996c..1e5c8f6 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -434,7 +434,7 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     0, 0, syndrome,
 			     chan, rank, -1,
-			     msg, detail, NULL);
+			     msg, detail);
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
@@ -456,7 +456,7 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 			     0, 0, syndrome,
 			     chan, rank, -1,
-			     msg, detail, NULL);
+			     msg, detail);
 }
 
 static void i5100_read_log(struct mem_ctl_info *mci, int chan,
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 90fad3a..f2bfc26 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -557,7 +557,7 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
 			     branch >> 1, -1, rank,
 			     rdwr ? "Write error" : "Read error",
-			     msg, NULL);
+			     msg);
 }
 
 /*
@@ -629,7 +629,7 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
 				     branch >> 1, channel % 2, rank,
 				     rdwr ? "Write error" : "Read error",
-				     msg, NULL);
+				     msg);
 
 		return;
 	}
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 738b891..4a8835f 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -452,7 +452,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
 				     branch, -1, rank,
 				     is_wr ? "Write error" : "Read error",
-				     pvt->tmp_prt_buffer, NULL);
+				     pvt->tmp_prt_buffer);
 
 	}
 
@@ -499,7 +499,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 				     syndrome,
 				     branch >> 1, channel % 2, rank,
 				     is_wr ? "Write error" : "Read error",
-				     pvt->tmp_prt_buffer, NULL);
+				     pvt->tmp_prt_buffer);
 	}
 	return;
 }
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 0899d7d..aba8d51 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1545,7 +1545,7 @@ static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
 
 	for (i = 0; i < add; i++) {
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
-				     chan, dimm, -1, "error", "", NULL);
+				     chan, dimm, -1, "error", "");
 	}
 }
 
@@ -1801,7 +1801,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				     m->addr & ~PAGE_MASK,
 				     syndrome,
 				     channel, dimm, -1,
-				     err, msg, m);
+				     err, msg);
 }
 
 /*
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 475bde1..1c414a8 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -159,7 +159,7 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0, -1, mci->ctl_name, "", NULL);
+					     0, -1, mci->ctl_name, "");
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
@@ -168,7 +168,7 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
-					     0, -1, mci->ctl_name, "", NULL);
+					     0, -1, mci->ctl_name, "");
 	}
 
 	return error_found;
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 832e7dd..ff4f590 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -110,7 +110,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
-				     -1, -1, -1, "UE overwrote CE", "", NULL);
+				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -122,12 +122,12 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, 0,
 				     dimm->location[0], dimm->location[1], -1,
-				     "i82860 UE", "", NULL);
+				     "i82860 UE", "");
 	else
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, info->derrsyn,
 				     dimm->location[0], dimm->location[1], -1,
-				     "i82860 CE", "", NULL);
+				     "i82860 CE", "");
 
 	return 1;
 }
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index db64bd7..2e3f306 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -238,7 +238,7 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 				     -1, -1, -1,
-				     "UE overwrote CE", "", NULL);
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -249,12 +249,12 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     info->eap, 0, 0,
 				     row, -1, -1,
-				     "i82875p UE", "", NULL);
+				     "i82875p UE", "");
 	else
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     info->eap, 0, info->derrsyn,
 				     row, multi_chan ? (info->des & 0x1) : 0,
-				     -1, "i82875p CE", "", NULL);
+				     -1, "i82875p CE", "");
 
 	return 1;
 }
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 974d1a2..c95ebe5 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -289,7 +289,7 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
-				     -1, -1, -1, "UE overwrote CE", "", NULL);
+				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -317,12 +317,12 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offst, 0,
 				     row, -1, -1,
-				     "i82975x UE", "", NULL);
+				     "i82975x UE", "");
 	else
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offst, info->derrsyn,
 				     row, chan ? chan : 0, -1,
-				     "i82975x CE", "", NULL);
+				     "i82975x CE", "");
 
 	return 1;
 }
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 64b4765..56e79a0 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -869,13 +869,13 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
 				     row_index, 0, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 
 	if (err_detect & DDR_EDE_MBE)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
 				     row_index, 0, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
 }
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index f54b3cb..e491a29 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -615,13 +615,13 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, syndrome,
 				     0, 0, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 	else	/* 2 bit error, UE */
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, 0,
 				     0, 0, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 
 	/* clear the error */
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ADDR, 0);
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 44f73b0..04851be5 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -112,14 +112,14 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     mci->csrows[cs]->first_page, 0, 0,
-				     cs, 0, -1, mci->ctl_name, "", NULL);
+				     cs, 0, -1, mci->ctl_name, "");
 	}
 
 	/* correctable/single-bit errors */
 	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     mci->csrows[cs]->first_page, 0, 0,
-				     cs, 0, -1, mci->ctl_name, "", NULL);
+				     cs, 0, -1, mci->ctl_name, "");
 }
 
 static void pasemi_edac_check(struct mem_ctl_info *mci)
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 5351982..67a2920 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -730,7 +730,7 @@ ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     0, 0, 0,
 					     row, 0, -1,
-					     message, "", NULL);
+					     message, "");
 }
 
 /**
@@ -761,7 +761,7 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 					     page, offset, 0,
 					     row, 0, -1,
-					     message, "", NULL);
+					     message, "");
 }
 
 /**
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index b68e734..aa10178 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -183,7 +183,7 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 					     page, 0, syndrome,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1,
-					     mci->ctl_name, "", NULL);
+					     mci->ctl_name, "");
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -195,7 +195,7 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 					     page, 0, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1,
-					     mci->ctl_name, "", NULL);
+					     mci->ctl_name, "");
 	}
 
 	return error_found;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 05955bf..ae18d98 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1450,12 +1450,12 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	edac_mc_handle_error(tp_event, mci,
 			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
 			     channel, dimm, -1,
-			     optype, msg, m);
+			     optype, msg);
 	return;
 err_parsing:
 	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
 			     -1, -1, -1,
-			     msg, "", m);
+			     msg, "");
 
 }
 
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index fc77f77..0589f56 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -74,7 +74,7 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
 				     0, 0, -1,
-				     mci->ctl_name, "", NULL);
+				     mci->ctl_name, "");
 	}
 }
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 0e1581a..3d46d40 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -217,7 +217,7 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 				     -1, -1, -1,
-				     "UE overwrote CE", "", NULL);
+				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
 
@@ -228,13 +228,13 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 					     0, 0, 0,
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "x38 UE", "", NULL);
+					     "x38 UE", "");
 		} else if (log & X38_ECCERRLOG_CE) {
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-					     "x38 CE", "", NULL);
+					     "x38 CE", "");
 		}
 	}
 }
-- 
1.7.10.2

