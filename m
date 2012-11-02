Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab2KBI4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:56:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50577 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab2KBI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:56:34 -0400
X-AuditID: cbfee61b-b7f616d00000319b-b4-50938ac07466
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kyungmin park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Turquette <mturquette@ti.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] Devfreq: Add debugfs node for representing frequency
 transition information
Date: Fri, 02 Nov 2012 17:56:27 +0900
Message-id: <1351846587-16376-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t8zHd0DXZMDDE7tUbS4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcvKxXML2LsWJTz33GBsYleV2MnBwSAiYSC/c3MkHY
	YhIX7q1n62Lk4hASWMYocWHrM0aYojPfZ7JDJBYxSrRtvAeWEBJoYZJ4NpsHxGYT0JH4v+8m
	O4gtIiAjMfXKflaQBmaB54wSt4/vYQZJCAvESex50AS2jkVAVeJux12wOK+Ah8SC/glsENsU
	JBbce8sGUSMg8W3yIZYuRg6guKzEpgPMIDMlBI6wSbzdtYEVol5S4uCKGywTGAUXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAgJL+kdjKsaLA4xCnAwKvHwWqyYFCDEmlhWXJl7iFGC
	g1lJhPc4SIg3JbGyKrUoP76oNCe1+BCjD9AlE5mlRJPzgaGfVxJvaGxgbGhoaWhmamlqgENY
	SZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjQq4Qg0pt641upg9it7cdfbVqx5vF3ZbSd14X
	unh/5P2ksmmNUexzybkcD3cd5amPzVrWoVK2l9nrgpPQ+/MCW5TiT+lNL65WvWQ/ee6DhTdc
	GRte2GmuePo90CZ9U8JHG/9zPeoPXBJCv/Kv1bz1NUDK4dyF5cv1Bf6qJ4u+0jgdpMU79fIE
	JZbijERDLeai4kQACSr/uFwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jAd0DXZMDDJ58kLK4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3LysVzC9i7Fi
	U899xgbGJXldjJwcEgImEme+z2SHsMUkLtxbz9bFyMUhJLCIUaJt4z1GkISQQAuTxLPZPCA2
	m4COxP99N8EaRARkJKZe2c8K0sAs8JxR4vbxPcwgCWGBOIk9D5qYQGwWAVWJux13weK8Ah4S
	C/onsEFsU5BYcO8t2wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgoP3mfQOxlUN
	FocYBTgYlXh4LVZMChBiTSwrrsw9xCjBwawkwnscJMSbklhZlVqUH19UmpNafIjRB2j7RGYp
	0eR8YGTllcQbGpuYGVkamRmbmBsb4xBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cA4M25y
	dODXwqQUL7MWYXW5/evZLzQILNRJPvF5+sstd3y/lv++dElwUcQPjdUri+M3P72R+4Tn4pUL
	ix6l5p3cUffr3+ZjRjcsWJLVfs0rfnbC/sKk1d//+iz33PgtxnMdr4Ol6Zfrp3MXb6s5z+r1
	tzDG59z5E9tYGd56X79w5MDzuamTLb6djVJiKc5INNRiLipOBAAhDXA9iwIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds debugfs node to measure transition of frequency on runtime.
It will be creted under '/sys/kernel/debugfs/devfreq/'dev name'/' as the name
of 'trans_table'. It contains number of transition of each frequency level,
time spent on each level, and also total transition count.
It inspired by CPUFREQ's cpufreq_stats method.

<Example of table>
=================================================================================
		  <freq level #1>   <freq level #2>  <freq level #3>  time spent
* <freq level #1>                         n12             n13             t1
  <freq level #2>       n21                               n23             t2
  <freq level #3>       n31               n32                             t3

Total transition :	N (= n12 + n13 + n21 + n23 + n31 + n32)
==================================================================================
(n12 : Number of transition from level 1 to level 2)
('*' : The last changed frequency when you inspect the node.)

This patch also includes documentation.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 Documentation/devfreq/transition_status_table |  265 +++++++++++++++++++++++++
 drivers/devfreq/devfreq.c                     |  123 ++++++++++++
 include/linux/devfreq.h                       |   23 +++
 3 files changed, 411 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devfreq/transition_status_table

diff --git a/Documentation/devfreq/transition_status_table b/Documentation/devfreq/transition_status_table
new file mode 100644
index 0000000..8b92391
--- /dev/null
+++ b/Documentation/devfreq/transition_status_table
@@ -0,0 +1,265 @@
+DEVFREQ Transition status table
+=========================================
+
+Copyright (C) 2012 Samsung Electronics
+
+Written by Jonghwa Lee <jonghwa3.lee@samsung.com>
+
+1. Description
+----------------
+
+DEVFREQ Transition status table represents all of transition information up to now. Transition information
+includes number of transition which has been occured and time spent on the each of frequencies.
+This implementation is ispired by CPUFREQ's cpufreq_stats method.
+
+<Example of table>
+============================================================================================================
+			<freq level #1>		<freq level #2>		<freq level #3>		time spent
+
+* <freq level #1>				Number of transition	Number of transition	   t1
+						from freq1 to freq2	from freq1 to freq3
+
+  <freq level #2>	Number of transition				Number of transition	   t2
+			from freq2 to freq1				from freq2 to freq3
+
+  <freq level #3>	Number of transition	Number of transition				   t3
+			from freq3 to freq1	from freq3 to freq2
+
+Total transition :	N
+=============================================================================================================
+('*' : The last changed frequency when you inspect the node.)
+
+It may be used for measuring performance or debug use.
+
+
+2. Requirement to use
+-----------------------
+
+There is no kernel configuration option for creating this node at this moment. Only CONFIG_DEBUG_FS is required.
+It will be created automatically when devfreq device created successfully.
+(under /sys/kernel/debug/devfreq/'each devfreq device name'/ by the name of 'trans_table'.)
+
+By the way, it's going to show nothing unless you go through the below steps.
+To show appropriate information about frequency transition, each devfreq device must hand over their own list of
+available frequency and total count of frequency levels to the framework. Because at the devfreq core side,
+system doesn't know how many freqeuncy levels are available and what value of each level exactly is.
+In devfreq_dev_profile structure, freq_list and freq_levs will play the role carrying the those requirement data.
+
+To guarantee trans_table working, following two steps are required.
+(1) Initialize the freq_list of devfreq_dev_profile with all available freqeuncy data
+(2) Initialize the freq_levs of devfreq_dev_profile with total number of available freqeuncy level.
+
+3. Guage performance
+----------------------
+
+This program is user space program that measures the frequency transition during the certain interval you set.
+When the program starts, it parses the trans_table contents and stores it for later comparison at the end.
+And when you stop the gauging, the program will calculate transition information happened during the interval given.
+The result is also formed like transition status table. However it can be used for more specific purpose and usefully
+than trans_table itself. By analyzing its data, we can get an indicator of performance of various situations or
+performance of governor and others also.
+
+HOW TO USE
+-----------
+1. Set the device name correctly in the code to the variable 'dev_name[]' before the compile.
+   This will be used to get the path of debugfs node. (Default is 'exynos4412-busfreq').
+2. Run the program, and you'll see comments of '### Press any key to start, 'q' to exit >>' or error massage.
+3. Input any key then it starts measurement with comments 'Gauging start...' and '### Press any key....'.
+4. Press any key again. It shows the result of measurement directly.
+5. Program will repeat step 2.
+
+<guage_devfreq.c>
+------------------
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <termios.h>
+
+#define EXTRA_LINE	3
+#define SEC_TO_MSEC	1000
+
+/* FIXME :
+ * Before compile this program,
+ * you shoud fix dev_name[] with device name
+ * which will be tested.
+ */
+/* for exynos4412 */
+char dev_name[] = "exynos4412-busfreq";
+
+struct trans_info {
+	unsigned int max_state;
+	unsigned int *freq;
+	unsigned int *trans_table;
+	unsigned long *time_in_state;
+};
+
+int parse_status(char *fpath, struct trans_info *info)
+{
+	int i, j;
+	char buf[256];
+	unsigned int ntrans;
+	unsigned long time;
+	int max_state = info->max_state;
+	FILE *fp;
+
+	fp = fopen(fpath, "r");
+	if (fp == NULL) {
+		printf("ERR: Coudn't open the file. \n");
+		return -EINVAL;
+	}
+	if(!info->freq[0]) {
+		/* Init freq array with presented frequency */
+		fgets(buf, 256, fp);
+		fgets(buf, 11, fp);
+
+		for (i = 0; i < max_state; i++)
+			fscanf(fp, "%8d",&info->freq[i]);
+
+		fgets(buf, 13, fp);
+	} else {
+		/* Already initialized freq array. Ignore header */
+		fgets(buf, 256, fp);
+		fgets(buf, 256, fp);
+	}
+	for (i = 0; i < max_state; i++) {
+			fgets(buf, 11, fp);
+		for(j = 0; j < max_state; j++) {
+			fscanf(fp, "%8u",&ntrans);
+			info->trans_table[(max_state * i) + j]  =
+				ntrans - info->trans_table[(max_state * i) + j];
+		}
+			fscanf(fp, "%10lu", &time);
+			info->time_in_state[i] = time - info->time_in_state[i];
+			fgetc(fp);
+	}
+
+	return 0;
+}
+
+void show_table(struct trans_info *info)
+{
+	int i, j;
+	unsigned long total_period = 0;
+	int max_state = info->max_state;
+
+	printf("\n\n");
+	for (i = 0; i < (info->max_state / 2) + 1; i++)
+		printf("\t");
+	printf("<Guaging result>\n");
+
+	/* Print table bar */
+	printf("   From  :   To\n");
+	printf("         :");
+	for (i = 0; i < max_state; i++)
+		printf("%8u", info->freq[i]);
+
+	printf("   time(ms)\n");
+
+	/* Print table entry */
+	for (i = 0; i < max_state; i++) {
+
+		printf("%8u:", info->freq[i]);
+
+		for (j = 0; j < max_state; j++)
+			printf("%8u", info->trans_table[(i *
+					max_state) + j]);
+
+		printf("%10lu\n", info->time_in_state[i]);
+		total_period += info->time_in_state[i];
+	}
+
+
+	printf("Total period : %lu\n", total_period / SEC_TO_MSEC);
+	return;
+}
+
+struct trans_info *trans_info_init(char *fpath)
+{
+	struct trans_info *info;
+	FILE *fp;
+	char buf[256];
+	int cnt = 0;
+
+	fp = fopen(fpath, "r");
+	if (fp == NULL) {
+		fprintf(stderr, "ERROR: Coudn't open the file. \n");
+		exit(errno);
+	}
+
+	/* Count number of lines in table */
+	while (fgets(buf, 256, fp)) {
+		cnt++;
+	}
+
+	info = malloc(sizeof(struct trans_info));
+	info->max_state = cnt - EXTRA_LINE;
+	info->freq = malloc(sizeof(unsigned int) * info->max_state);
+	info->trans_table = malloc(sizeof(unsigned int) * info->max_state
+							* info->max_state);
+	info->time_in_state = malloc(sizeof(unsigned long) * info->max_state);
+
+	fclose(fp);
+
+	return info;
+}
+
+int getch()
+{
+	struct termios oldt, newt;
+	int ch;
+
+	tcgetattr(STDIN_FILENO, &oldt);
+	newt = oldt;
+	newt.c_lflag &= ~(ICANON | ECHO);
+	tcsetattr(STDIN_FILENO, TCSANOW, &newt);
+	ch = getchar();
+	tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
+	return ch;
+}
+
+int main(int argc, char **argv) {
+
+	FILE *fp;
+	struct trans_info *info;
+	char ch, fpath[256];
+	int res;
+
+	strcpy(fpath, "/sys/class/devfreq/");
+	strcat(fpath, dev_name);
+	strcat(fpath, "/trans_stat");
+
+	info = trans_info_init(fpath);
+	if (info == NULL) {
+		fprintf(stderr, "ERROR: Initialization failed\n");
+		exit(errno);
+	}
+
+	printf("### Press any key to start, 'q' to exit >>");
+	ch = getch();
+	if (ch == 'q') {
+		printf("\n\nFinish the guaging....\n");
+		return 0;
+	} else {
+		printf("\nGuaging start...\n");
+		printf("### Press any key to stop guaging >>");
+
+		/* Parse trans_stat */
+		res = parse_status(fpath, info);
+		if (res)
+			return res;
+
+		ch = getch();
+		/* Re-Parse trans_stat after duration */
+		res = parse_status(fpath, info);
+		if (res)
+			return res;
+
+		show_table(info);
+	}
+
+	return 0;
+}
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index b146d76..6012b09 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -27,6 +27,8 @@
 #include <linux/hrtimer.h>
 #include "governor.h"
 
+#include <linux/debugfs.h>
+
 struct class *devfreq_class;
 
 /*
@@ -46,6 +48,8 @@ static struct devfreq *wait_remove_device;
 static LIST_HEAD(devfreq_list);
 static DEFINE_MUTEX(devfreq_list_lock);
 
+static struct dentry *devfreq_debugfs;
+
 /**
  * find_device_devfreq() - find devfreq struct using device pointer
  * @dev:	device pointer used to lookup device devfreq.
@@ -72,6 +76,40 @@ static struct devfreq *find_device_devfreq(struct device *dev)
 	return ERR_PTR(-ENODEV);
 }
 
+int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
+{
+	int lev;
+
+	for (lev = 0; lev < devfreq->profile->freq_levs; lev++)
+		if (freq == devfreq->profile->freq_list[lev])
+			return lev;
+
+	return -EINVAL;
+}
+
+int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
+{
+	int lev, prev_lev;
+	unsigned long cur_time;
+
+	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
+	if (prev_lev < 0)
+		return lev;
+
+	cur_time = jiffies;
+	devfreq->time_in_state[prev_lev] +=
+			 cur_time - devfreq->last_trinfo_updated;
+	if (freq != devfreq->previous_freq) {
+		lev = devfreq_get_freq_level(devfreq, freq);
+		devfreq->trans_table[(prev_lev *
+				devfreq->profile->freq_levs) + lev]++;
+		devfreq->total_trans++;
+	}
+	devfreq->last_trinfo_updated = cur_time;
+
+	return 0;
+}
+
 /**
  * update_devfreq() - Reevaluate the device and configure frequency.
  * @devfreq:	the devfreq instance.
@@ -116,6 +154,11 @@ int update_devfreq(struct devfreq *devfreq)
 	if (err)
 		return err;
 
+	if (devfreq->profile->freq_list)
+		if (devfreq_update_status(devfreq, freq))
+			dev_err(&devfreq->dev,
+				"Couldn't update frequency transition information.\n");
+
 	devfreq->previous_freq = freq;
 	return err;
 }
@@ -179,6 +222,8 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
 
 	devfreq->being_removed = true;
 
+	debugfs_remove_recursive(devfreq->debugfs);
+
 	if (devfreq->profile->exit)
 		devfreq->profile->exit(devfreq->dev.parent);
 
@@ -336,6 +381,59 @@ static void devfreq_monitor(struct work_struct *work)
 	}
 }
 
+static ssize_t show_trans_table(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct devfreq *devfreq = file->private_data;
+	ssize_t len = 0;
+	int i, j, err;
+	unsigned int freq_levs = devfreq->profile->freq_levs;
+
+	err = devfreq_update_status(devfreq, devfreq->previous_freq);
+	if (err)
+		return 0;
+
+	len = snprintf(buf, PAGE_SIZE, "   From  :   To\n");
+	len += snprintf(buf + len, PAGE_SIZE - len, "         :");
+	for (i = 0; i < freq_levs; i++)
+		len += snprintf(buf + len, PAGE_SIZE - len, "%8u",
+				devfreq->profile->freq_list[i]);
+
+	len += snprintf(buf + len, PAGE_SIZE - len, "   time(ms)\n");
+
+	for (i = 0; i < freq_levs; i++) {
+		if (devfreq->profile->freq_list[i]
+					== devfreq->previous_freq) {
+			len += snprintf(buf + len, PAGE_SIZE - len, "*");
+		} else {
+			len += snprintf(buf + len, PAGE_SIZE - len, " ");
+		}
+		len += snprintf(buf + len, PAGE_SIZE - len, "%8u:",
+				devfreq->profile->freq_list[i]);
+		for (j = 0; j < freq_levs; j++)
+			len += snprintf(buf + len, PAGE_SIZE - len, "%8u",
+				devfreq->trans_table[(i * freq_levs) + j]);
+		len += snprintf(buf + len, PAGE_SIZE - len, "%10u\n",
+			jiffies_to_msecs(devfreq->time_in_state[i]));
+	}
+
+	len += snprintf(buf + len, PAGE_SIZE - len, "Total transition : %u\n",
+					devfreq->total_trans);
+
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+
+	return len;
+}
+
+static const struct file_operations devfreq_trans_table_fops = {
+	.open		= simple_open,
+	.read		= show_trans_table,
+	.llseek		= default_llseek,
+};
+
 /**
  * devfreq_add_device() - Add devfreq feature to the device
  * @dev:	the device to add devfreq feature.
@@ -390,6 +488,15 @@ struct devfreq *devfreq_add_device(struct device *dev,
 			      = msecs_to_jiffies(devfreq->profile->polling_ms);
 	devfreq->nb.notifier_call = devfreq_notifier_call;
 
+	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
+						devfreq->profile->freq_levs *
+						devfreq->profile->freq_levs,
+						GFP_KERNEL);
+	devfreq->time_in_state = devm_kzalloc(dev, sizeof(unsigned int) *
+						devfreq->profile->freq_levs,
+						GFP_KERNEL);
+	devfreq->last_trinfo_updated = jiffies;
+
 	dev_set_name(&devfreq->dev, dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
@@ -417,6 +524,16 @@ struct devfreq *devfreq_add_device(struct device *dev,
 				   devfreq->next_polling);
 	}
 	mutex_unlock(&devfreq_list_lock);
+
+	mutex_lock(&devfreq->lock);
+	if (!IS_ERR(devfreq_debugfs)) {
+		devfreq->debugfs = debugfs_create_dir(dev_name(dev),
+							devfreq_debugfs);
+		debugfs_create_file("trans_table", S_IRUGO, devfreq->debugfs,
+					devfreq, &devfreq_trans_table_fops);
+	}
+	mutex_unlock(&devfreq->lock);
+
 out:
 	return devfreq;
 
@@ -623,12 +740,18 @@ static int __init devfreq_init(void)
 		return PTR_ERR(devfreq_class);
 	}
 	devfreq_class->dev_attrs = devfreq_attrs;
+
+	devfreq_debugfs = debugfs_create_dir("devfreq", NULL);
+	if (IS_ERR(devfreq_debugfs))
+		pr_err("%s: couldn't create debugfs\n", __FILE__);
+
 	return 0;
 }
 subsys_initcall(devfreq_init);
 
 static void __exit devfreq_exit(void)
 {
+	debugfs_remove(devfreq_debugfs);
 	class_destroy(devfreq_class);
 }
 module_exit(devfreq_exit);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 281c72a..d9cce45 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -57,6 +57,10 @@ struct devfreq_dev_status {
  * @initial_freq	The operating frequency when devfreq_add_device() is
  *			called.
  * @polling_ms		The polling interval in ms. 0 disables polling.
+ *
+ * @freq_list		List for all availble frequencies in this DEVFREQ.
+ * @freq_levs		Total number of frequncy levels.
+ *
  * @target		The device should set its operating frequency at
  *			freq or lowest-upper-than-freq value. If freq is
  *			higher than any operable frequency, set maximum.
@@ -71,11 +75,16 @@ struct devfreq_dev_status {
  *			from devfreq_remove_device() call. If the user
  *			has registered devfreq->nb at a notifier-head,
  *			this is the time to unregister it.
+ *
+ * @
  */
 struct devfreq_dev_profile {
 	unsigned long initial_freq;
 	unsigned int polling_ms;
 
+	unsigned int *freq_list;
+	unsigned int freq_levs;
+
 	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
@@ -137,6 +146,12 @@ struct devfreq_governor {
  * @min_freq	Limit minimum frequency requested by user (0: none)
  * @max_freq	Limit maximum frequency requested by user (0: none)
  *
+ * @total_trans			Total trasition number.
+ * @trans_table			Transition count of each frequency level.
+ * @time_in_state		Spent time of each freqeuncy level.
+ * @last_trinfo_updated		Time mark of last transition information updating.
+ *
+ * @debgufs
  * This structure stores the devfreq information for a give device.
  *
  * Note that when a governor accesses entries in struct devfreq in its
@@ -164,6 +179,14 @@ struct devfreq {
 
 	unsigned long min_freq;
 	unsigned long max_freq;
+
+	/* information for device freqeuncy transition */
+	unsigned int total_trans;
+	unsigned int *trans_table;
+	unsigned long *time_in_state;
+	unsigned long last_trinfo_updated;
+
+	struct dentry *debugfs;
 };
 
 #if defined(CONFIG_PM_DEVFREQ)
-- 
1.7.4.1

